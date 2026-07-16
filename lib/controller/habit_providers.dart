import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optimos/model/database.dart';
import 'package:optimos/model/habits_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

final habitsDaoProvider = Provider<HabitsDao>((ref) {
  final db = ref.watch(databaseProvider);
  return HabitsDao(db);
});

final activeHabitsProvider = StreamProvider.family<List<Habit>, DateTime>((ref, date) {
  final dao = ref.watch(habitsDaoProvider);
  return dao.watchActiveHabits(date);
});

final habitProgressProvider = StreamProvider.family<int, (String, DateTime)>((ref, args) {
  final (habitId, date) = args;
  final dao = ref.watch(habitsDaoProvider);
  return dao.watchProgress(habitId, date);
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
    );
    await dao.insertHabit(companion);
    state = const AsyncData(null);
  }

  Future<void> toggleCompletion(String habitId, DateTime date, bool currentlyCompleted) async {
    final dao = ref.read(habitsDaoProvider);
    if (!currentlyCompleted) {
      await dao.logCompletion(habitId, date);
    } else {
      await dao.removeCompletion(habitId, date);
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