import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/core/database/database.dart';
import 'package:kaizen/features/habits/application/habit_providers.dart';
import 'package:kaizen/features/dashboard/data/health_repository.dart';

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return HealthRepository(db);
});

// --- Water ---
final waterEntriesProvider = StreamProvider<List<WaterEntry>>((ref) {
  final repo = ref.watch(healthRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return repo.watchWaterEntries(selectedDate);
});

final waterIntakeProvider = Provider<double>((ref) {
  final entries = ref.watch(waterEntriesProvider).value ?? [];
  return entries.fold(0.0, (sum, entry) => sum + entry.amount);
});

// Group water entries into specific time bins (6-8a, 9-11a, 11-2p, 2-4p, 4p-Now)
final waterHourlyIntakeProvider = Provider<Map<String, double>>((ref) {
  final entries = ref.watch(waterEntriesProvider).value ?? [];
  final bins = {
    '6-8a': 0.0,
    '9-11a': 0.0,
    '11-2p': 0.0,
    '2-4p': 0.0,
    '4p-Now': 0.0,
  };
  for (final entry in entries) {
    final hour = entry.createdAt.hour;
    if (hour >= 6 && hour < 9) {
      bins['6-8a'] = (bins['6-8a'] ?? 0) + entry.amount;
    } else if (hour >= 9 && hour < 11) {
      bins['9-11a'] = (bins['9-11a'] ?? 0) + entry.amount;
    } else if (hour >= 11 && hour < 14) {
      bins['11-2p'] = (bins['11-2p'] ?? 0) + entry.amount;
    } else if (hour >= 14 && hour < 16) {
      bins['2-4p'] = (bins['2-4p'] ?? 0) + entry.amount;
    } else if (hour >= 16) {
      bins['4p-Now'] = (bins['4p-Now'] ?? 0) + entry.amount;
    }
  }
  return bins;
});

// --- Sleep ---
final sleepRecordsProvider = StreamProvider<List<SleepRecord>>((ref) {
  final repo = ref.watch(healthRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return repo.watchSleepRecords(selectedDate);
});

final sleepDurationProvider = Provider<double>((ref) {
  final records = ref.watch(sleepRecordsProvider).value ?? [];
  if (records.isEmpty) return 0.0;
  
  double totalHours = 0.0;
  for (final record in records) {
    final duration = record.wakeupTime.difference(record.bedtime);
    totalHours += duration.inMinutes / 60.0;
  }
  return totalHours;
});

// Stream for the past 7 days of sleep records for the weekly consistency chart
final weeklySleepRecordsProvider = StreamProvider<List<SleepRecord>>((ref) {
  final repo = ref.watch(healthRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  
  // Actually, we need a method in the repo to fetch range, but for now we can just use the DB directly here or add a repo method.
  // We'll add watchSleepRecordsRange to HealthRepository.
  final start = selectedDate.subtract(const Duration(days: 6));
  final end = selectedDate;
  return repo.watchSleepRecordsRange(start, end);
});

// --- Calories ---
final calorieEntriesProvider = StreamProvider<List<CalorieEntry>>((ref) {
  final repo = ref.watch(healthRepositoryProvider);
  final selectedDate = ref.watch(selectedDateProvider);
  return repo.watchCalorieEntries(selectedDate);
});

final caloriesProvider = Provider<int>((ref) {
  final entries = ref.watch(calorieEntriesProvider).value ?? [];
  return entries.fold(0, (sum, entry) => sum + entry.calories);
});

// Group calorie entries into meal types
final calorieDistributionProvider = Provider<Map<String, int>>((ref) {
  final entries = ref.watch(calorieEntriesProvider).value ?? [];
  final bins = {
    'Breakfast': 0,
    'Morning Snack': 0,
    'Lunch': 0,
    'Afternoon Snack': 0,
    'Dinner': 0,
  };
  for (final entry in entries) {
    if (bins.containsKey(entry.mealType)) {
      bins[entry.mealType] = bins[entry.mealType]! + entry.calories;
    } else {
      // fallback
      bins['Dinner'] = bins['Dinner']! + entry.calories;
    }
  }
  return bins;
});
