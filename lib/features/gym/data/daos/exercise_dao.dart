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
    // Remove all current exercises completely
    await delete(exercises).go();

    final defaultExercises = [
      // 1. LEG PRESS MACHINE
      ExercisesCompanion.insert(id: const Value('leg_press_standard'), name: 'Standard Stance Leg Press', primaryMuscles: [MuscleGroup.quads], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('leg_press_high_foot'), name: 'High-Foot Leg Press', primaryMuscles: [MuscleGroup.glutes], secondaryMuscles: [MuscleGroup.hamstrings]),
      ExercisesCompanion.insert(id: const Value('leg_press_low_foot'), name: 'Low-Foot Leg Press', primaryMuscles: [MuscleGroup.quads], secondaryMuscles: [MuscleGroup.quads]),
      ExercisesCompanion.insert(id: const Value('leg_press_wide_stance'), name: 'Wide-Stance Leg Press', primaryMuscles: [MuscleGroup.adductors], secondaryMuscles: [MuscleGroup.adductors]),
      ExercisesCompanion.insert(id: const Value('leg_press_narrow_stance'), name: 'Narrow-Stance Leg Press', primaryMuscles: [MuscleGroup.quads], secondaryMuscles: [MuscleGroup.quads]),
      ExercisesCompanion.insert(id: const Value('leg_press_single_leg'), name: 'Single-Leg Press', primaryMuscles: [MuscleGroup.quads], secondaryMuscles: [MuscleGroup.glutes]),
      ExercisesCompanion.insert(id: const Value('leg_press_calf_raises'), name: 'Leg Press Calf Raises', primaryMuscles: [MuscleGroup.calves], secondaryMuscles: []),

      // 2. PECK DECK (FLY) MACHINE
      ExercisesCompanion.insert(id: const Value('pec_fly_standard'), name: 'Standard Pec Fly', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('pec_fly_low_pad'), name: 'Low-Pad Incline-Bias Pec Fly', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('pec_fly_single_arm'), name: 'Single-Arm Pec Fly', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('pec_deck_rear_delt'), name: 'Reverse Pec Deck Rear Delt Fly', primaryMuscles: [MuscleGroup.shoulders], secondaryMuscles: [MuscleGroup.back]),

      // 3. SMITH MACHINE
      ExercisesCompanion.insert(id: const Value('smith_squat'), name: 'Smith Machine Squat', primaryMuscles: [MuscleGroup.quads], secondaryMuscles: [MuscleGroup.glutes]),
      ExercisesCompanion.insert(id: const Value('smith_bulgarian_split'), name: 'Smith Bulgarian Split Squat', primaryMuscles: [MuscleGroup.glutes], secondaryMuscles: [MuscleGroup.quads]),
      ExercisesCompanion.insert(id: const Value('smith_rdl'), name: 'Smith Romanian Deadlift', primaryMuscles: [MuscleGroup.hamstrings], secondaryMuscles: [MuscleGroup.glutes]),
      ExercisesCompanion.insert(id: const Value('smith_hip_thrust'), name: 'Smith Hip Thrust', primaryMuscles: [MuscleGroup.glutes], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('smith_calf_raise'), name: 'Smith Standing Calf Raise', primaryMuscles: [MuscleGroup.calves], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('smith_flat_bench'), name: 'Smith Flat Bench Press', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: [MuscleGroup.triceps]),
      ExercisesCompanion.insert(id: const Value('smith_incline_bench'), name: 'Smith Incline Bench Press', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: [MuscleGroup.shoulders]),
      ExercisesCompanion.insert(id: const Value('smith_close_grip_bench'), name: 'Smith Close-Grip Bench Press', primaryMuscles: [MuscleGroup.triceps], secondaryMuscles: [MuscleGroup.chest]),
      ExercisesCompanion.insert(id: const Value('smith_overhead_press'), name: 'Smith Overhead Press', primaryMuscles: [MuscleGroup.shoulders], secondaryMuscles: [MuscleGroup.triceps]),
      ExercisesCompanion.insert(id: const Value('smith_upright_row'), name: 'Smith Upright Row', primaryMuscles: [MuscleGroup.shoulders], secondaryMuscles: [MuscleGroup.back]),
      ExercisesCompanion.insert(id: const Value('smith_bent_over_row'), name: 'Smith Bent-Over Row', primaryMuscles: [MuscleGroup.back], secondaryMuscles: [MuscleGroup.back]),
      ExercisesCompanion.insert(id: const Value('smith_shrugs'), name: 'Smith Shrugs', primaryMuscles: [MuscleGroup.back], secondaryMuscles: []),

      // 4. LEG CURL MACHINE
      ExercisesCompanion.insert(id: const Value('leg_curl_lying'), name: 'Lying Leg Curl', primaryMuscles: [MuscleGroup.hamstrings], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('leg_curl_seated'), name: 'Seated Leg Curl', primaryMuscles: [MuscleGroup.hamstrings], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('leg_curl_single_leg'), name: 'Single-Leg Curl', primaryMuscles: [MuscleGroup.hamstrings], secondaryMuscles: []),

      // 5. PREACHER MACHINE
      ExercisesCompanion.insert(id: const Value('preacher_curl_standard'), name: 'Standard Two-Arm Preacher Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('preacher_curl_single_arm'), name: 'Single-Arm Preacher Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('preacher_curl_reverse_grip'), name: 'Reverse-Grip Preacher Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: [MuscleGroup.forearms]),
      ExercisesCompanion.insert(id: const Value('preacher_curl_hammer'), name: 'Hammer Preacher Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: []),

      // 6. LAT PULLDOWN MACHINE
      ExercisesCompanion.insert(id: const Value('lat_pulldown_wide_grip'), name: 'Wide-Grip Lat Pulldown', primaryMuscles: [MuscleGroup.back], secondaryMuscles: [MuscleGroup.back]),
      ExercisesCompanion.insert(id: const Value('lat_pulldown_close_grip'), name: 'Close-Grip V-Bar Pulldown', primaryMuscles: [MuscleGroup.back], secondaryMuscles: [MuscleGroup.back]),
      ExercisesCompanion.insert(id: const Value('lat_pulldown_reverse_grip'), name: 'Reverse-Grip Underhand Pulldown', primaryMuscles: [MuscleGroup.back], secondaryMuscles: [MuscleGroup.biceps]),
      ExercisesCompanion.insert(id: const Value('lat_pulldown_neutral_grip'), name: 'Neutral-Grip Pulldown', primaryMuscles: [MuscleGroup.back], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('lat_pulldown_single_arm'), name: 'Single-Arm Lat Pulldown', primaryMuscles: [MuscleGroup.back], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('lat_pulldown_straight_arm'), name: 'Straight-Arm Pulldown', primaryMuscles: [MuscleGroup.back], secondaryMuscles: []),

      // 7. CABLE MACHINE
      ExercisesCompanion.insert(id: const Value('cable_fly_high_low'), name: 'High-to-Low Cable Fly', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_fly_mid'), name: 'Mid-Level Cable Fly', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_fly_low_high'), name: 'Low-to-High Cable Fly', primaryMuscles: [MuscleGroup.chest], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_face_pull'), name: 'Cable Face Pull', primaryMuscles: [MuscleGroup.shoulders], secondaryMuscles: [MuscleGroup.back]),
      ExercisesCompanion.insert(id: const Value('cable_lateral_raise'), name: 'Cable Lateral Raise', primaryMuscles: [MuscleGroup.shoulders], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_row_seated'), name: 'Seated Cable Row', primaryMuscles: [MuscleGroup.back], secondaryMuscles: [MuscleGroup.back]),
      ExercisesCompanion.insert(id: const Value('cable_triceps_pushdown'), name: 'Triceps Rope Pushdown', primaryMuscles: [MuscleGroup.triceps], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_triceps_overhead'), name: 'Overhead Cable Triceps Extension', primaryMuscles: [MuscleGroup.triceps], secondaryMuscles: [MuscleGroup.triceps]),
      ExercisesCompanion.insert(id: const Value('cable_biceps_curl'), name: 'Cable Biceps Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_biceps_bayesian'), name: 'Bayesian Cable Curl', primaryMuscles: [MuscleGroup.biceps], secondaryMuscles: [MuscleGroup.biceps]),
      ExercisesCompanion.insert(id: const Value('cable_crunch_kneeling'), name: 'Cable Kneeling Crunch', primaryMuscles: [MuscleGroup.abs], secondaryMuscles: []),
      ExercisesCompanion.insert(id: const Value('cable_woodchopper'), name: 'Cable Woodchopper', primaryMuscles: [MuscleGroup.obliques], secondaryMuscles: []),
    ];

    await batch((batch) {
      batch.insertAll(exercises, defaultExercises);
    });
  }
}
