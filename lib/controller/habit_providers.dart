import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:kaizen/model/database.dart';
import 'package:kaizen/model/habits_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final habitsDaoProvider = Provider<HabitsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return HabitsDao(db);
});

final activeHabitsProvider = StreamProvider.family<List<Habit>, DateTime>((ref, date) {
  final dao = ref.watch(habitsDaoProvider);
  return dao.watchActiveHabits(date);
});

final habitProgressProvider = StreamProvider.family<int, (Habit, DateTime)>((ref, args) {
  final (habit, date) = args;
  final dao = ref.watch(habitsDaoProvider);
  return dao.watchProgress(habit, date);
});

final habitYearlyProgressProvider = StreamProvider.family<Map<DateTime, int>, String>((ref, habitId) {
  final dao = ref.watch(habitsDaoProvider);
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 378)); // 54 weeks * 7 days
  
  return dao.watchLogsBetweenAll(start, end).map((logs) {
    final Map<DateTime, int> report = {};
    for (var log in logs) {
      if (log.habitId == habitId) {
        final d = DateTime(log.completedDate.year, log.completedDate.month, log.completedDate.day);
        report[d] = log.progress;
      }
    }
    return report;
  });
});

final weeklyReportProvider = StreamProvider<Map<DateTime, int>>((ref) {
  final dao = ref.watch(habitsDaoProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(const Duration(days: 6));
  
  final habitsAsync = ref.watch(activeHabitsProvider(today));
  
  // Explicitly typing <DateTime, int> stops the compiler from throwing type errors
  if (!habitsAsync.hasValue) {
    return Stream.value(<DateTime, int>{});
  }
  
  final activeHabits = habitsAsync.value!;
  final habitTargets = {for (var h in activeHabits) h.id: h.targetValue};
  
  return dao.watchLogsBetweenAll(start, today).map((logs) {
    final Map<DateTime, int> report = {};
    for (var log in logs) {
      final target = habitTargets[log.habitId] ?? 1;
      if (log.progress >= target) {
        report[log.completedDate] = (report[log.completedDate] ?? 0) + 1;
      }
    }
    return report;
  });
});

// Notifier for adding habits
class HabitNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addHabit({
    required String name,
    required String icon,
    required String color,
    required String frequency,
    String? reminderTime,
    bool isQuantitative = false,
    int targetValue = 1,
    String? unit,
    String? categories,
    String streakGoalInterval = 'none',
  }) async {
    state = const AsyncLoading();
    final dao = ref.read(habitsDaoProvider);
    final companion = HabitsCompanion(
      name: Value(name),
      icon: Value(icon),
      color: Value(color),
      frequency: Value(frequency),
      reminderTime: reminderTime == null ? const Value.absent() : Value(reminderTime),
      isQuantitative: Value(isQuantitative),
      targetValue: Value(targetValue),
      unit: unit == null ? const Value.absent() : Value(unit),
      categories: categories == null ? const Value.absent() : Value(categories),
      streakGoalInterval: Value(streakGoalInterval),
    );
    await dao.insertHabit(companion);
    state = const AsyncData(null);
  }

  Future<void> toggleCompletion(Habit habit, DateTime date, bool currentlyCompleted) async {
    final dao = ref.read(habitsDaoProvider);
    if (!currentlyCompleted) {
      await dao.logCompletion(habit.id, date);
    } else {
      await dao.removeCompletionForPeriod(habit, date);
    }
    state = const AsyncData(null);
  }

  Future<void> updateProgress(String habitId, DateTime date, int progress) async {
    final dao = ref.read(habitsDaoProvider);
    await dao.saveProgress(habitId, date, progress);
  }

  Future<void> deleteHabit(String habitId) async {
    final dao = ref.read(habitsDaoProvider);
    await dao.deleteHabit(habitId);
  }

  Future<void> archiveHabit(String habitId) async {
    final dao = ref.read(habitsDaoProvider);
    await dao.archiveHabit(habitId);
  }
}

final habitNotifierProvider = AsyncNotifierProvider<HabitNotifier, void>(() => HabitNotifier());

final globalHabitStreakProvider = StreamProvider<int>((ref) {
  final dao = ref.watch(habitsDaoProvider);
  final allHabitsStream = dao.watchAllHabits();
  final allLogsStream = dao.watchLogsBetweenAll(DateTime(2000, 1, 1), DateTime.now());

  return Rx.combineLatest2(allHabitsStream, allLogsStream, (List<Habit> habits, List<HabitLog> logs) {
    int streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Group logs by date and habitId
    final Map<DateTime, Set<String>> completedLogs = {};
    for (final log in logs) {
      try {
        final habit = habits.firstWhere((h) => h.id == log.habitId);
        if (log.progress >= habit.targetValue) {
          final d = DateTime(log.completedDate.year, log.completedDate.month, log.completedDate.day);
          completedLogs.putIfAbsent(d, () => <String>{}).add(log.habitId);
        }
      } catch (e) {
        // habit not found, skip
      }
    }

    for (int i = 0; i < 10000; i++) {
      final date = today.subtract(Duration(days: i));
      
      // Get all active habits for this date
      final activeHabitsForDate = habits.where((h) {
        if (h.frequency != 'daily') return false; 
        
        final createdBeforeEnd = h.createdAt.isBefore(DateTime(date.year, date.month, date.day, 23, 59, 59));
        final notArchived = h.archivedAt == null || h.archivedAt!.isAfter(date);
        return createdBeforeEnd && notArchived;
      }).toList();

      if (activeHabitsForDate.isEmpty) {
        if (i == 0) continue;
        break; 
      }
      
      bool allCompleted = true;
      final logsForDate = completedLogs[date] ?? {};
      for (final h in activeHabitsForDate) {
        if (!logsForDate.contains(h.id)) {
          allCompleted = false;
          break;
        }
      }
      
      if (allCompleted) {
        streak++;
      } else {
        if (i == 0) {
          continue; 
        } else {
          break; 
        }
      }
    }
    return streak;
  });
});