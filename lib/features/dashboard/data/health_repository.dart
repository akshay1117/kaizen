import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kaizen/core/models/health_models.dart';

class HealthRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser!.id;

  // --- Water ---
  Future<void> addWater(double amount, DateTime date) async {
    await _supabase.from('water_entries').insert({
      'user_id': _userId,
      'amount': amount,
      'date': date.toIso8601String(),
    });
  }

  Stream<List<WaterEntry>> watchWaterEntries(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day).toIso8601String();
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59).toIso8601String();
    
    return _supabase
        .from('water_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .gte('date', startOfDay)
        .lte('date', endOfDay)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => WaterEntry.fromJson(json)).toList());
  }

  Future<void> deleteWaterEntry(String id) async {
    await _supabase.from('water_entries').delete().eq('id', id);
  }

  // --- Sleep ---
  Future<void> addSleepRecord(DateTime bedtime, DateTime wakeupTime, int? score, DateTime date) async {
    await _supabase.from('sleep_records').insert({
      'user_id': _userId,
      'bedtime': bedtime.toIso8601String(),
      'wakeup_time': wakeupTime.toIso8601String(),
      'sleep_score': score,
      'date': date.toIso8601String().split('T').first,
    });
  }

  Stream<List<SleepRecord>> watchSleepRecords(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return watchSleepRecordsRange(startOfDay, endOfDay);
  }

  Stream<List<SleepRecord>> watchSleepRecordsRange(DateTime start, DateTime end) {
    final startStr = start.toIso8601String().split('T').first;
    final endStr = end.toIso8601String().split('T').first;

    return _supabase
        .from('sleep_records')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .gte('date', startStr)
        .lte('date', endStr)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => SleepRecord.fromJson(json)).toList());
  }

  Future<void> deleteSleepRecord(String id) async {
    await _supabase.from('sleep_records').delete().eq('id', id);
  }

  // --- Calories ---
  Future<void> addCalorieEntry(String mealType, String? name, int calories, DateTime date) async {
    await _supabase.from('calorie_entries').insert({
      'user_id': _userId,
      'meal_type': mealType,
      'name': name,
      'calories': calories,
      'date': date.toIso8601String().split('T').first,
    });
  }

  Stream<List<CalorieEntry>> watchCalorieEntries(DateTime date) {
    final dateStr = date.toIso8601String().split('T').first;
    
    return _supabase
        .from('calorie_entries')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .eq('date', dateStr)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => CalorieEntry.fromJson(json)).toList());
  }

  Future<void> deleteCalorieEntry(String id) async {
    await _supabase.from('calorie_entries').delete().eq('id', id);
  }
}
