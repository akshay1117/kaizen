import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:kaizen/core/models/habit_model.dart';
import 'package:kaizen/features/habits/data/habits_repository.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>((ref) {
  return HabitsRepository();
});

final activeHabitsProvider = StreamProvider.family<List<Habit>, DateTime>((ref, date) {
  final repo = ref.watch(habitsRepositoryProvider);
  return repo.watchActiveHabits(date);
});

final habitProgressProvider = StreamProvider.family<int, (Habit, DateTime)>((ref, args) {
  final (habit, date) = args;
  final repo = ref.watch(habitsRepositoryProvider);
  return repo.watchProgress(habit, date);
});

final habitYearlyProgressProvider = StreamProvider.family<Map<DateTime, int>, String>((ref, habitId) {
  final repo = ref.watch(habitsRepositoryProvider);
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 378)); // 54 weeks * 7 days
  
  return repo.watchLogsBetweenAll(start, end).map((logs) {
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
  final repo = ref.watch(habitsRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final start = today.subtract(const Duration(days: 6));
  
  final habitsAsync = ref.watch(activeHabitsProvider(today));
  
  if (!habitsAsync.hasValue) {
    return Stream.value(<DateTime, int>{});
  }
  
  final activeHabits = habitsAsync.value!;
  final habitTargets = {for (var h in activeHabits) h.id: h.targetValue};
  
  return repo.watchLogsBetweenAll(start, today).map((logs) {
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

final dailyHabitCompletionPercentageProvider = StreamProvider<double>((ref) {
  final repo = ref.watch(habitsRepositoryProvider);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  final habitsAsync = ref.watch(activeHabitsProvider(today));
  
  if (!habitsAsync.hasValue || habitsAsync.value!.isEmpty) {
    return Stream.value(0.0);
  }
  
  final activeHabits = habitsAsync.value!;
  
  return repo.watchLogsBetweenAll(today, today).map((logs) {
    int completedCount = 0;
    
    for (var habit in activeHabits) {
      final log = logs.where((l) => l.habitId == habit.id).firstOrNull;
      final progress = log?.progress ?? 0;
      final target = habit.targetValue;
      
      if (progress >= target) {
        completedCount++;
      }
    }
    
    return completedCount / activeHabits.length;
  });
});

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
    final repo = ref.read(habitsRepositoryProvider);
    final habit = Habit(
      id: const Uuid().v4(),
      userId: Supabase.instance.client.auth.currentUser!.id,
      name: name,
      icon: icon,
      color: color,
      frequency: frequency,
      reminderTime: reminderTime,
      isQuantitative: isQuantitative,
      targetValue: targetValue,
      unit: unit,
      categories: categories,
      streakGoalInterval: streakGoalInterval,
      createdAt: DateTime.now(),
    );
    await repo.insertHabit(habit);
    state = const AsyncData(null);
  }

  Future<void> toggleCompletion(Habit habit, DateTime date, bool currentlyCompleted) async {
    final repo = ref.read(habitsRepositoryProvider);
    if (!currentlyCompleted) {
      await repo.saveProgress(habit.id, date, habit.targetValue);
    } else {
      await repo.saveProgress(habit.id, date, 0);
    }
    state = const AsyncData(null);
  }

  Future<void> updateProgress(String habitId, DateTime date, int progress) async {
    final repo = ref.read(habitsRepositoryProvider);
    await repo.saveProgress(habitId, date, progress);
  }

  Future<void> deleteHabit(String habitId) async {
    final repo = ref.read(habitsRepositoryProvider);
    await repo.deleteHabit(habitId);
  }

  Future<void> archiveHabit(String habitId) async {
    final repo = ref.read(habitsRepositoryProvider);
    await repo.archiveHabit(habitId);
  }
}

final habitNotifierProvider = AsyncNotifierProvider<HabitNotifier, void>(() => HabitNotifier());

final globalHabitStreakProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(habitsRepositoryProvider);
  final allHabitsStream = repo.watchAllHabits();
  final allLogsStream = repo.watchLogsBetweenAll(DateTime(2000, 1, 1), DateTime.now());

  return Rx.combineLatest2(allHabitsStream, allLogsStream, (List<Habit> habits, List<HabitLog> logs) {
    int streak = 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
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