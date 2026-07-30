import 'package:drift/drift.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

part 'workout_dao.g.dart';

@DriftAccessor(tables: [Workouts, WorkoutGroups])
class WorkoutDao extends DatabaseAccessor<GymDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  Stream<List<Workout>> watchUngroupedWorkouts() {
    return (select(workouts)..where((t) => t.groupId.isNull())).watch();
  }

  Stream<List<WorkoutGroup>> watchAllGroups() {
    return select(workoutGroups).watch();
  }

  Stream<List<Workout>> watchWorkoutsInGroup(String groupId) {
    return (select(workouts)..where((t) => t.groupId.equals(groupId))).watch();
  }

  Future<int> insertWorkout(WorkoutsCompanion workout) {
    return into(workouts).insert(workout);
  }

  Future<int> insertGroup(WorkoutGroupsCompanion group) {
    return into(workoutGroups).insert(group);
  }

  Future<int> deleteWorkout(Workout workout) {
    return delete(workouts).delete(workout);
  }

  Future<int> deleteWorkoutGroup(WorkoutGroup group) {
    return delete(workoutGroups).delete(group);
  }
}
