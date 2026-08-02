import 'package:drift/drift.dart';
import 'package:kaizen/model/database.dart';

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

  // Remove completion for a specific period
  Future<void> removeCompletionForPeriod(Habit habit, DateTime date) async {
    DateTime start;
    DateTime end;
    
    if (habit.frequency == 'weekly') {
      final int diff = date.weekday - DateTime.monday;
      start = date.subtract(Duration(days: diff));
      end = start.add(const Duration(days: 6));
    } else if (habit.frequency == 'monthly') {
      start = DateTime(date.year, date.month, 1);
      end = DateTime(date.year, date.month + 1, 0); 
    } else {
      start = date;
      end = date;
    }

    await (delete(habitLogs)
          ..where((l) => l.habitId.equals(habit.id) & l.completedDate.isBetweenValues(start, end)))
        .go();
    await _recalculateStreak(habit.id);
  }

  // Watch progress for the habit's period
  Stream<int> watchProgress(Habit habit, DateTime date) {
    DateTime start;
    DateTime end;
    
    if (habit.frequency == 'weekly') {
      final int diff = date.weekday - DateTime.monday;
      start = date.subtract(Duration(days: diff));
      end = start.add(const Duration(days: 6));
    } else if (habit.frequency == 'monthly') {
      start = DateTime(date.year, date.month, 1);
      end = DateTime(date.year, date.month + 1, 0); 
    } else {
      start = date;
      end = date;
    }

    return (select(habitLogs)..where((l) => l.habitId.equals(habit.id) & l.completedDate.isBetweenValues(start, end)))
        .watch()
        .map((logs) {
          int totalProgress = 0;
          for (final log in logs) {
            totalProgress += log.progress;
          }
          return totalProgress;
        });
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

  // Watch all habits (including archived ones)
  Stream<List<Habit>> watchAllHabits() => select(habits).watch();

  // Recalculate all streaks (useful for app startup)
  Future<void> recalculateAllStreaks() async {
    final allHabits = await select(habits).get();
    for (var habit in allHabits) {
      await _recalculateStreak(habit.id);
    }
  }

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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final log in logs) {
      final date = DateTime(log.completedDate.year, log.completedDate.month, log.completedDate.day);
      if (lastDate == null) {
        if (habit.frequency == 'daily') {
          if (today.difference(date).inDays > 1) {
            break;
          }
        } else if (habit.frequency == 'weekly') {
          final startOfTodayWeek = today.subtract(Duration(days: today.weekday - 1));
          final startOfLogWeek = date.subtract(Duration(days: date.weekday - 1));
          if (startOfTodayWeek.difference(startOfLogWeek).inDays > 7) {
            break;
          }
        } else if (habit.frequency == 'monthly') {
          final diffMonths = (today.year - date.year) * 12 + (today.month - date.month);
          if (diffMonths > 1) {
            break;
          }
        }
        streak = 1;
        lastDate = date;
        continue;
      }
      
      if (habit.frequency == 'daily') {
        final difference = lastDate.difference(date).inDays;
        if (difference == 1) {
          streak++;
          lastDate = date;
        } else {
          break;
        }
      } else if (habit.frequency == 'weekly') {
        final startOfLastWeek = lastDate.subtract(Duration(days: lastDate.weekday - 1));
        final startOfLogWeek = date.subtract(Duration(days: date.weekday - 1));
        if (startOfLastWeek.difference(startOfLogWeek).inDays == 7) {
          streak++;
          lastDate = date;
        } else {
          break;
        }
      } else if (habit.frequency == 'monthly') {
        final diffMonths = (lastDate.year - date.year) * 12 + (lastDate.month - date.month);
        if (diffMonths == 1) {
          streak++;
          lastDate = date;
        } else {
          break;
        }
      }
    }
    
    await (update(habits)..where((h) => h.id.equals(habitId))).write(HabitsCompanion(currentStreak: Value(streak)));
  }
}