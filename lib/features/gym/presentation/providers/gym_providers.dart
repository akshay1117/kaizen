import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/domain/gym_use_cases.dart';
import 'package:kaizen/features/gym/data/daos/programme_dao.dart';

// Re-export the SINGLE canonical database provider so all consumers
// share the same GymDatabase instance (and thus the same SQLite connection).
export 'package:kaizen/features/gym/presentation/providers/gym_database_provider.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_database_provider.dart';

// Re-export the canonical DAO providers from their dedicated files
// so existing `gym_providers.dart` importers still find them.
export 'package:kaizen/features/gym/presentation/providers/workout_providers.dart'
    show workoutDaoProvider;
export 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart'
    show exerciseDaoProvider;

import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';
import 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart';

// --- Programme DAO (only defined here) ---
final programmeDaoProvider = Provider<ProgrammeDao>((ref) {
  return ProgrammeDao(ref.watch(gymDatabaseProvider));
});

// --- Stream Providers for Real-time UI updates ---

final exercisesStreamProvider = StreamProvider<List<Exercise>>((ref) {
  final dao = ref.watch(exerciseDaoProvider);
  return dao.watchAllExercises();
});

final workoutsStreamProvider = StreamProvider<List<Workout>>((ref) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchAllWorkouts();
});

final workoutSessionsStreamProvider = StreamProvider<List<WorkoutSession>>((ref) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchAllSessions();
});

final allSetEntriesStreamProvider = StreamProvider<List<SetEntry>>((ref) {
  final dao = ref.watch(workoutDaoProvider);
  return dao.watchAllSetEntries();
});

// --- Derived Logic Providers ---

final currentStreakProvider = Provider<int>((ref) {
  final sessionsAsync = ref.watch(workoutSessionsStreamProvider);
  return sessionsAsync.when(
    data: (sessions) => GymUseCases.calculateCurrentStreak(sessions.map((s) => s.date).toList()),
    loading: () => 0,
    error: (_, __) => 0,
  );
});

final isRestDayProvider = Provider<bool>((ref) {
  final sessionsAsync = ref.watch(workoutSessionsStreamProvider);
  return sessionsAsync.when(
    data: (sessions) => GymUseCases.isRestDay(sessions.map((s) => s.date).toList()),
    loading: () => false,
    error: (_, __) => false,
  );
});

final muscleRecoveryProvider = Provider<Map<MuscleGroup, double>>((ref) {
  final setsAsync = ref.watch(allSetEntriesStreamProvider);
  final exercisesAsync = ref.watch(exercisesStreamProvider);
  
  // Default to fully recovered
  Map<MuscleGroup, double> recoveryMap = {
    for (var group in MuscleGroup.values) group: 1.0
  };

  if (setsAsync.hasValue && exercisesAsync.hasValue) {
    final sets = setsAsync.value!;
    final exercises = exercisesAsync.value!;
    
    // Map exerciseId to primary muscles
    Map<String, List<MuscleGroup>> exerciseMuscles = {};
    for (var ex in exercises) {
      exerciseMuscles[ex.id] = ex.primaryMuscles;
    }

    // Find latest training time for each muscle
    Map<MuscleGroup, DateTime> lastTrainedMap = {};
    for (var set in sets) {
      final muscles = exerciseMuscles[set.exerciseId] ?? [];
      for (var muscle in muscles) {
        if (!lastTrainedMap.containsKey(muscle) || set.performedAt.isAfter(lastTrainedMap[muscle]!)) {
          lastTrainedMap[muscle] = set.performedAt;
        }
      }
    }

    // Assuming 3 days full recovery for now (can be fetched from settings)
    const fullRecoveryDays = 3;

    for (var muscle in MuscleGroup.values) {
      if (lastTrainedMap.containsKey(muscle)) {
        recoveryMap[muscle] = GymUseCases.calculateRecoveryPercentage(lastTrainedMap[muscle], fullRecoveryDays);
      }
    }
  }

  return recoveryMap;
});

final muscleLastTrainedProvider = Provider<Map<MuscleGroup, DateTime>>((ref) {
  final setsAsync = ref.watch(allSetEntriesStreamProvider);
  final exercisesAsync = ref.watch(exercisesStreamProvider);
  
  Map<MuscleGroup, DateTime> lastTrainedMap = {};

  if (setsAsync.hasValue && exercisesAsync.hasValue) {
    final sets = setsAsync.value!;
    final exercises = exercisesAsync.value!;
    
    Map<String, List<MuscleGroup>> exerciseMuscles = {};
    for (var ex in exercises) {
      exerciseMuscles[ex.id] = ex.primaryMuscles;
    }

    for (var set in sets) {
      final muscles = exerciseMuscles[set.exerciseId] ?? [];
      for (var muscle in muscles) {
        if (!lastTrainedMap.containsKey(muscle) || set.performedAt.isAfter(lastTrainedMap[muscle]!)) {
          lastTrainedMap[muscle] = set.performedAt;
        }
      }
    }
  }

  return lastTrainedMap;
});

final todayStatsProvider = Provider<Map<String, String>>((ref) {
  final setsAsync = ref.watch(allSetEntriesStreamProvider);
  final sessionsAsync = ref.watch(workoutSessionsStreamProvider);

  if (!setsAsync.hasValue || !sessionsAsync.hasValue) {
    return {'sets': '0', 'reps': '0', 'exercises': '0', 'volume': '0 kg', 'duration': '0m'};
  }

  final now = DateTime.now();
  final todaySets = setsAsync.value!.where((s) => s.performedAt.year == now.year && s.performedAt.month == now.month && s.performedAt.day == now.day).toList();
  final todaySessions = sessionsAsync.value!.where((s) => s.date.year == now.year && s.date.month == now.month && s.date.day == now.day).toList();

  int totalSets = todaySets.length;
  int totalReps = todaySets.fold(0, (sum, set) => sum + set.reps);
  int uniqueExercises = todaySets.map((s) => s.exerciseId).toSet().length;
  double volume = todaySets.fold(0.0, (sum, set) => sum + (set.weightKg * set.reps));
  
  int durationSeconds = todaySessions.fold(0, (sum, session) => sum + (session.durationSeconds ?? 0));
  int durationMinutes = (durationSeconds / 60).floor();

  return {
    'sets': totalSets.toString(),
    'reps': totalReps.toString(),
    'exercises': uniqueExercises.toString(),
    'volume': '${volume.toStringAsFixed(0)} kg',
    'duration': '${durationMinutes}m',
  };
});

