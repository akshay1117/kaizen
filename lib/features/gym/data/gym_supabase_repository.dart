import 'package:supabase_flutter/supabase_flutter.dart';
// Note: You would import your domain models here to map the JSON to Dart objects.
// import 'package:kaizen/features/gym/domain/models/gym_models.dart';

class GymSupabaseRepository {
  final SupabaseClient _client = Supabase.instance.client;

  // --- Exercises ---
  Future<List<Map<String, dynamic>>> getExercises() async {
    final response = await _client.from('exercises').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addExercise(Map<String, dynamic> exercise) async {
    await _client.from('exercises').insert(exercise);
  }

  // --- Workouts ---
  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final response = await _client.from('workouts').select();
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addWorkout(Map<String, dynamic> workout) async {
    await _client.from('workouts').insert(workout);
  }

  // --- Sets ---
  Future<List<Map<String, dynamic>>> getSetsForSession(String sessionId) async {
    final response = await _client
        .from('set_entries')
        .select()
        .eq('workout_session_id', sessionId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> addSet(Map<String, dynamic> setEntry) async {
    await _client.from('set_entries').insert(setEntry);
  }
}
