import 'package:drift/drift.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

part 'workout_dao.g.dart';

@DriftAccessor(tables: [Workouts, WorkoutGroups, WorkoutSessions, SetEntries, WorkoutSteps, Exercises])
class WorkoutDao extends DatabaseAccessor<GymDatabase> with _$WorkoutDaoMixin {
  WorkoutDao(super.db);

  Stream<List<Workout>> watchAllWorkouts() {
    return select(workouts).watch();
  }

  Stream<List<WorkoutSession>> watchAllSessions() {
    return select(workoutSessions).watch();
  }

  Stream<List<SetEntry>> watchAllSetEntries() {
    return select(setEntries).watch();
  }

  Stream<List<Workout>> watchUngroupedWorkouts() {
    return (select(workouts)..where((t) => t.groupId.isNull())).watch();
  }

  Stream<List<WorkoutGroup>> watchAllGroups() {
    return select(workoutGroups).watch();
  }

  Stream<List<Workout>> watchWorkoutsInGroup(String groupId) {
    return (select(workouts)..where((t) => t.groupId.equals(groupId))).watch();
  }

  Stream<List<Exercise>> watchExercisesForWorkout(String workoutId) {
    final query = select(workoutSteps).join([
      innerJoin(exercises, exercises.id.equalsExp(workoutSteps.refId)),
    ])..where(workoutSteps.workoutId.equals(workoutId))
      ..where(workoutSteps.stepType.equals(0)) // 0 = exercise
      ..orderBy([OrderingTerm.asc(workoutSteps.stepOrder)]);
    
    return query.watch().map((rows) {
      return rows.map((row) => row.readTable(exercises)).toList();
    });
  }

  Future<int> insertWorkoutStep(WorkoutStepsCompanion step) {
    return into(workoutSteps).insert(step);
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

  Future<int> insertSetEntry(SetEntriesCompanion entry) {
    return into(setEntries).insert(entry);
  }

  Future<int> insertWorkoutSession(WorkoutSessionsCompanion session) {
    return into(workoutSessions).insert(session);
  }
}
