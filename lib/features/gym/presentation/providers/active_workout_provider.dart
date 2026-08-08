import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/data/daos/workout_dao.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:drift/drift.dart' as drift;

class ActiveWorkoutSet {
  final String id;
  final double weight;
  final int reps;
  final bool isCompleted;

  ActiveWorkoutSet({
    required this.id,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });

  ActiveWorkoutSet copyWith({
    double? weight,
    int? reps,
    bool? isCompleted,
  }) {
    return ActiveWorkoutSet(
      id: id,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ActiveWorkoutExercise {
  final String id; // Exercise ID from DB
  final String name;
  final String muscleGroup;
  final List<ActiveWorkoutSet> sets;

  ActiveWorkoutExercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.sets,
  });

  ActiveWorkoutExercise copyWith({
    List<ActiveWorkoutSet>? sets,
  }) {
    return ActiveWorkoutExercise(
      id: id,
      name: name,
      muscleGroup: muscleGroup,
      sets: sets ?? this.sets,
    );
  }
}

class ActiveWorkoutState {
  final bool isActive;
  final String title;
  final DateTime? startTime;
  final int elapsedSeconds;
  final List<ActiveWorkoutExercise> exercises;

  ActiveWorkoutState({
    this.isActive = false,
    this.title = 'Workout',
    this.startTime,
    this.elapsedSeconds = 0,
    this.exercises = const [],
  });

  ActiveWorkoutState copyWith({
    bool? isActive,
    String? title,
    DateTime? startTime,
    int? elapsedSeconds,
    List<ActiveWorkoutExercise>? exercises,
  }) {
    return ActiveWorkoutState(
      isActive: isActive ?? this.isActive,
      title: title ?? this.title,
      startTime: startTime ?? this.startTime,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      exercises: exercises ?? this.exercises,
    );
  }
}

class ActiveWorkoutNotifier extends StateNotifier<ActiveWorkoutState> {
  final WorkoutDao _workoutDao;
  Timer? _timer;

  ActiveWorkoutNotifier(this._workoutDao) : super(ActiveWorkoutState());

  void startWorkout(String title) {
    _timer?.cancel();
    state = ActiveWorkoutState(
      isActive: true,
      title: title,
      startTime: DateTime.now(),
      elapsedSeconds: 0,
    );
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
      }
    });
  }

  void addExercise(Exercise exercise) {
    if (!state.isActive) return;
    
    final newExercise = ActiveWorkoutExercise(
      id: exercise.id,
      name: exercise.name,
      muscleGroup: exercise.primaryMuscles.isNotEmpty ? exercise.primaryMuscles.first.name : 'Other',
      sets: [
        ActiveWorkoutSet(id: DateTime.now().toString(), weight: 0, reps: 0),
      ],
    );

    state = state.copyWith(
      exercises: [...state.exercises, newExercise],
    );
  }

  void addSet(String exerciseId) {
    if (!state.isActive) return;
    
    final updatedExercises = state.exercises.map((ex) {
      if (ex.id == exerciseId) {
        // Copy the last set's weight/reps as defaults if they exist
        double newWeight = 0;
        int newReps = 0;
        if (ex.sets.isNotEmpty) {
          newWeight = ex.sets.last.weight;
          newReps = ex.sets.last.reps;
        }
        return ex.copyWith(sets: [
          ...ex.sets,
          ActiveWorkoutSet(
            id: DateTime.now().toString(), 
            weight: newWeight, 
            reps: newReps
          )
        ]);
      }
      return ex;
    }).toList();

    state = state.copyWith(exercises: updatedExercises);
  }

  void updateSet(String exerciseId, String setId, {double? weight, int? reps}) {
    if (!state.isActive) return;
    
    final updatedExercises = state.exercises.map((ex) {
      if (ex.id == exerciseId) {
        final updatedSets = ex.sets.map((set) {
          if (set.id == setId) {
            return set.copyWith(weight: weight, reps: reps);
          }
          return set;
        }).toList();
        return ex.copyWith(sets: updatedSets);
      }
      return ex;
    }).toList();

    state = state.copyWith(exercises: updatedExercises);
  }

  void toggleSetCompletion(String exerciseId, String setId) {
    if (!state.isActive) return;
    
    final updatedExercises = state.exercises.map((ex) {
      if (ex.id == exerciseId) {
        final updatedSets = ex.sets.map((set) {
          if (set.id == setId) {
            return set.copyWith(isCompleted: !set.isCompleted);
          }
          return set;
        }).toList();
        return ex.copyWith(sets: updatedSets);
      }
      return ex;
    }).toList();

    state = state.copyWith(exercises: updatedExercises);
  }

  Future<void> finishWorkout() async {
    _timer?.cancel();
    
    // Create Workout Session
    final sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    await _workoutDao.insertWorkoutSession(
      WorkoutSessionsCompanion.insert(
        id: drift.Value(sessionId),
        date: drift.Value(state.startTime ?? DateTime.now()),
        durationSeconds: drift.Value(state.elapsedSeconds),
      )
    );
    
    // Insert all completed sets
    for (var ex in state.exercises) {
      for (var set in ex.sets) {
        if (set.isCompleted) {
          await _workoutDao.insertSetEntry(
            SetEntriesCompanion.insert(
              exerciseId: ex.id,
              workoutSessionId: drift.Value(sessionId),
              weightKg: set.weight,
              reps: set.reps,
              performedAt: drift.Value(DateTime.now()),
            )
          );
        }
      }
    }
    
    state = state.copyWith(isActive: false);
  }
  
  void clearWorkout() {
    _timer?.cancel();
    state = ActiveWorkoutState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final activeWorkoutProvider = StateNotifierProvider<ActiveWorkoutNotifier, ActiveWorkoutState>((ref) {
  final workoutDao = ref.watch(workoutDaoProvider);
  return ActiveWorkoutNotifier(workoutDao);
});
