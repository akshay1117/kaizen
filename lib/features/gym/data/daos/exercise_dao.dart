import 'package:drift/drift.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

part 'exercise_dao.g.dart';

@DriftAccessor(tables: [Exercises])
class ExerciseDao extends DatabaseAccessor<GymDatabase> with _$ExerciseDaoMixin {
  ExerciseDao(super.db);

  Stream<List<Exercise>> watchAllExercises() {
    return (select(exercises)..orderBy([(t) => OrderingTerm(expression: t.name, mode: OrderingMode.asc)])).watch();
  }

  Future<int> insertExercise(ExercisesCompanion exercise) {
    return into(exercises).insert(exercise);
  }

  Future<int> deleteExercise(Exercise exercise) {
    return delete(exercises).delete(exercise);
  }

  Future<void> seedDefaultExercises() async {
    final list = await select(exercises).get();
    if (list.isNotEmpty) return;

    final defaultExercises = [
      ExercisesCompanion.insert(name: 'Bench Press', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: [MuscleGroup.triceps, MuscleGroup.shoulders]),
      ExercisesCompanion.insert(name: 'Squat', primaryMuscles: [MuscleGroup.quads, MuscleGroup.glutes], secondaryMuscles: [MuscleGroup.hamstrings]),
      ExercisesCompanion.insert(name: 'Deadlift', primaryMuscles: [MuscleGroup.glutes, MuscleGroup.hamstrings, MuscleGroup.back], secondaryMuscles: [MuscleGroup.forearms]),
      ExercisesCompanion.insert(name: 'Overhead Press', primaryMuscles: [MuscleGroup.shoulders], secondaryMuscles: [MuscleGroup.triceps]),
      ExercisesCompanion.insert(name: 'Barbell Row', primaryMuscles: [MuscleGroup.back], secondaryMuscles: [MuscleGroup.biceps]),
      ExercisesCompanion.insert(name: 'Pull-up', primaryMuscles: [MuscleGroup.back, MuscleGroup.biceps], secondaryMuscles: []),
      ExercisesCompanion.insert(name: 'Dumbbell Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: []),
      ExercisesCompanion.insert(name: 'Triceps Extension', primaryMuscles: [MuscleGroup.triceps], secondaryMuscles: []),
      ExercisesCompanion.insert(name: 'Leg Press', primaryMuscles: [MuscleGroup.quads, MuscleGroup.glutes], secondaryMuscles: []),
      ExercisesCompanion.insert(name: 'Calf Raise', primaryMuscles: [MuscleGroup.calves], secondaryMuscles: []),
      ExercisesCompanion.insert(name: 'Crunch', primaryMuscles: [MuscleGroup.abs], secondaryMuscles: []),
    ];

    await batch((batch) {
      batch.insertAll(exercises, defaultExercises);
    });
  }
}
