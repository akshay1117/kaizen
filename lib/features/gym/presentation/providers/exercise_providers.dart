import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/data/daos/exercise_dao.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_database_provider.dart';

final exerciseDaoProvider = Provider<ExerciseDao>((ref) {
  return ExerciseDao(ref.watch(gymDatabaseProvider));
});

final allExercisesProvider = StreamProvider<List<Exercise>>((ref) {
  final dao = ref.watch(exerciseDaoProvider);
  return dao.watchAllExercises();
});
