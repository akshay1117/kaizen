import 'package:drift/drift.dart';
import 'package:optimos/model/database.dart';

part 'habits_dao.g.dart';

@DriftAccessor(tables: [Habits, HabitLogs])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.db);

  // Stream all active habits for a specific date
  Stream<List<Habit>> watchActiveHabits(DateTime date) {
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return (select(habits)..where((h) => 
        h.createdAt.isSmallerOrEqualValue(endOfDay) &
        (h.archivedAt.isNull() | h.archivedAt.isBiggerThanValue(date))
    )).watch();
  }

  // Insert habit
  Future<void> insertHabit(HabitsCompanion habit) => into(habits).insert(habit);

  // Update habit
  Future<void> updateHabit(Habit habit) => update(habits).replace(habit);

  // Archive habit (soft delete)
  Future<void> archiveHabit(String id) =>
      (update(habits)..where((h) => h.id.equals(id))).write(HabitsCompanion(archivedAt: Value(DateTime.now())));

  // Hard delete habit
  Future<void> deleteHabit(String id) async {
    await (delete(habitLogs)..where((l) => l.habitId.equals(id))).go();
    await (delete(habits)..where((h) => h.id.equals(id))).go();
  }

  // Log completion
  Future<void> logCompletion(String habitId, DateTime date, {String? note}) async {
    await into(habitLogs).insert(HabitLogsCompanion(
      habitId: Value(habitId),
      completedDate: Value(date),
      progress: const Value(1),
      note: note == null ? const Value.absent() : Value(note),
    ));
    // Recalculate streak after insert
    await _recalculateStreak(habitId);
  }

  // Remove completion
  Future<void> removeCompletion(String habitId, DateTime date) async {
    await (delete(habitLogs)
          ..where((l) => l.habitId.equals(habitId) & l.completedDate.equals(date)))
        .go();
    await _recalculateStreak(habitId);
  }

  // Watch progress for a specific day
  Stream<int> watchProgress(String habitId, DateTime date) {
    return (select(habitLogs)..where((l) => l.habitId.equals(habitId) & l.completedDate.equals(date)))
        .watchSingleOrNull()
        .map((log) => log?.progress ?? 0);
  }

  // Save/Update progress
  Future<void> saveProgress(String habitId, DateTime date, int progress, {String? note}) async {
    final existing = await (select(habitLogs)..where((l) => l.habitId.equals(habitId) & l.completedDate.equals(date))).getSingleOrNull();
    if (existing != null) {
      if (progress <= 0) {
        await removeCompletion(habitId, date);
      } else {
        await (update(habitLogs)..where((l) => l.id.equals(existing.id)))
            .write(HabitLogsCompanion(progress: Value(progress)));
        await _recalculateStreak(habitId);
      }
    } else if (progress > 0) {
      await into(habitLogs).insert(HabitLogsCompanion(
        habitId: Value(habitId),
        completedDate: Value(date),
        progress: Value(progress),
        note: note == null ? const Value.absent() : Value(note),
      ));
      await _recalculateStreak(habitId);
    }
  }

  // Check if habit was completed on a given date
  Future<bool> isCompleted(String habitId, DateTime date) async {
    final query = select(habitLogs)
      ..where((l) => l.habitId.equals(habitId) & l.completedDate.equals(date));
    final count = await query.get().then((list) => list.length);
    return count > 0;
  }

  // Get logs for a date range
  Future<List<HabitLog>> getLogsBetween(String habitId, DateTime start, DateTime end) =>
      (select(habitLogs)
            ..where((l) => l.habitId.equals(habitId) & l.completedDate.isBetweenValues(start, end)))
          .get();

  // Get all logs for a date range (useful for weekly report)
  Stream<List<HabitLog>> watchLogsBetweenAll(DateTime start, DateTime end) =>
      (select(habitLogs)..where((l) => l.completedDate.isBetweenValues(start, end))).watch();

  // Private: recalculate streak based on consecutive days
  Future<void> _recalculateStreak(String habitId) async {
    final habit = await (select(habits)..where((h) => h.id.equals(habitId))).getSingle();
    final logs = await (select(habitLogs)
          ..where((l) => l.habitId.equals(habitId) & l.progress.isBiggerOrEqualValue(habit.targetValue))
          ..orderBy([(l) => OrderingTerm.desc(l.completedDate)]))
        .get();

    if (logs.isEmpty) {
      await (update(habits)..where((h) => h.id.equals(habitId))).write(const HabitsCompanion(currentStreak: Value(0)));
      return;
    }

    int streak = 0;
    DateTime? lastDate;
    for (final log in logs) {
      final date = log.completedDate;
      if (lastDate == null) {
        streak = 1;
        lastDate = date;
        continue;
      }
      final difference = lastDate.difference(date).inDays;
      if (difference == 1) {
        streak++;
        lastDate = date;
      } else {
        break;
      }
    }
    await (update(habits)..where((h) => h.id.equals(habitId))).write(HabitsCompanion(currentStreak: Value(streak)));
  }
}