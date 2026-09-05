import 'package:drift/drift.dart';
import 'package:kaizen/core/database/database.dart';

class HealthRepository {
  final AppDatabase db;

  HealthRepository(this.db);

  // --- Water ---
  Future<void> addWater(double amount, DateTime date) {
    return db.into(db.waterEntries).insert(WaterEntriesCompanion.insert(
      amount: amount,
      date: date,
    ));
  }

  Stream<List<WaterEntry>> watchWaterEntries(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (db.select(db.waterEntries)
          ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> deleteWaterEntry(String id) {
    return (db.delete(db.waterEntries)..where((t) => t.id.equals(id))).go();
  }

  // --- Sleep ---
  Future<void> addSleepRecord(DateTime bedtime, DateTime wakeupTime, int? score, DateTime date) {
    return db.into(db.sleepRecords).insert(SleepRecordsCompanion.insert(
      bedtime: bedtime,
      wakeupTime: wakeupTime,
      sleepScore: Value(score),
      date: date,
    ));
  }

  Stream<List<SleepRecord>> watchSleepRecords(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return watchSleepRecordsRange(startOfDay, endOfDay);
  }

  Stream<List<SleepRecord>> watchSleepRecordsRange(DateTime start, DateTime end) {
    return (db.select(db.sleepRecords)
          ..where((t) => t.date.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> deleteSleepRecord(String id) {
    return (db.delete(db.sleepRecords)..where((t) => t.id.equals(id))).go();
  }

  // --- Calories ---
  Future<void> addCalorieEntry(String mealType, String? name, int calories, DateTime date) {
    return db.into(db.calorieEntries).insert(CalorieEntriesCompanion.insert(
      mealType: mealType,
      name: Value(name),
      calories: calories,
      date: date,
    ));
  }

  Stream<List<CalorieEntry>> watchCalorieEntries(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (db.select(db.calorieEntries)
          ..where((t) => t.date.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> deleteCalorieEntry(String id) {
    return (db.delete(db.calorieEntries)..where((t) => t.id.equals(id))).go();
  }
}
