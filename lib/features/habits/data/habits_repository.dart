import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kaizen/core/models/habit_model.dart';

class HabitsRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser!.id;

  // Stream all active habits
  Stream<List<Habit>> watchActiveHabits(DateTime date) {
    return _supabase
        .from('habits')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .order('created_at')
        .map((data) => data.map((json) => Habit.fromJson(json)).where((h) {
              final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);
              final isCreatedBefore = h.createdAt.isBefore(endOfDay) || h.createdAt.isAtSameMomentAs(endOfDay);
              final isNotArchived = h.archivedAt == null || h.archivedAt!.isAfter(date);
              return isCreatedBefore && isNotArchived;
            }).toList());
  }

  // Watch all habits (including archived)
  Stream<List<Habit>> watchAllHabits() {
    return _supabase
        .from('habits')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .order('created_at')
        .map((data) => data.map((json) => Habit.fromJson(json)).toList());
  }

  // Insert habit
  Future<void> insertHabit(Habit habit) async {
    await _supabase.from('habits').insert(habit.toJson());
  }

  // Update habit
  Future<void> updateHabit(Habit habit) async {
    await _supabase.from('habits').update(habit.toJson()).eq('id', habit.id);
  }

  // Archive habit (soft delete)
  Future<void> archiveHabit(String id) async {
    await _supabase.from('habits').update({'archived_at': DateTime.now().toIso8601String()}).eq('id', id);
  }

  // Hard delete habit
  Future<void> deleteHabit(String id) async {
    await _supabase.from('habits').delete().eq('id', id);
  }

  // Watch progress
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

    final startStr = start.toIso8601String().split('T').first;
    final endStr = end.toIso8601String().split('T').first;

    return _supabase
        .from('habit_logs')
        .stream(primaryKey: ['id'])
        .eq('habit_id', habit.id)
        .gte('completed_date', startStr)
        .lte('completed_date', endStr)
        .map((logs) {
          int totalProgress = 0;
          for (final log in logs) {
            totalProgress += log['progress'] as int? ?? 1;
          }
          return totalProgress;
        });
  }

  // Save progress
  Future<void> saveProgress(String habitId, DateTime date, int progress, {String? note}) async {
    final dateStr = date.toIso8601String().split('T').first;
    
    final existingLogs = await _supabase
        .from('habit_logs')
        .select()
        .eq('habit_id', habitId)
        .eq('completed_date', dateStr);

    if (existingLogs.isNotEmpty) {
      if (progress <= 0) {
        await _supabase.from('habit_logs').delete().eq('id', existingLogs.first['id']);
      } else {
        await _supabase.from('habit_logs').update({'progress': progress}).eq('id', existingLogs.first['id']);
      }
    } else if (progress > 0) {
      await _supabase.from('habit_logs').insert({
        'habit_id': habitId,
        'user_id': _userId,
        'completed_date': dateStr,
        'progress': progress,
        'note': note,
      });
    }
  }

  // Get logs between dates
  Stream<List<HabitLog>> watchLogsBetweenAll(DateTime start, DateTime end) {
    final startStr = start.toIso8601String().split('T').first;
    final endStr = end.toIso8601String().split('T').first;
    
    return _supabase
        .from('habit_logs')
        .stream(primaryKey: ['id'])
        .eq('user_id', _userId)
        .gte('completed_date', startStr)
        .lte('completed_date', endStr)
        .map((data) => data.map((json) => HabitLog.fromJson(json)).toList());
  }

  // Recalculate streak
  // Simple streak recalculation for frontend (could be moved to Edge Function eventually)
  Future<void> recalculateStreak(String habitId) async {
    // This requires fetching all logs for the habit, sorting, and calculating.
    // For now we will update the streak to whatever simple logic we need.
    // Omitting complex calculation for brevity in frontend rewriting phase.
  }
}
