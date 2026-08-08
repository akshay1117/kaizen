import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/data/daos/workout_dao.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_database_provider.dart';

final workoutDaoProvider = Provider<WorkoutDao>((ref) {
  return WorkoutDao(ref.watch(gymDatabaseProvider));
});

// Provides stream of all ungrouped workouts
final ungroupedWorkoutsProvider = StreamProvider<List<Workout>>((ref) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchUngroupedWorkouts();
});

// Provides stream of all workout groups
final workoutGroupsProvider = StreamProvider<List<WorkoutGroup>>((ref) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchAllGroups();
});

// Provides stream of exercises for a specific workout
final workoutExercisesProvider = StreamProvider.family<List<Exercise>, String>((ref, workoutId) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchExercisesForWorkout(workoutId);
});
