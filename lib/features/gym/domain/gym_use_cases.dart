import 'package:kaizen/features/gym/data/gym_database.dart';

class GymUseCases {
  // --- 1RM Calculations ---
  // w = weight, r = reps
  // Epley: w * (1 + r / 30)
  // Brzycki: w * 36 / (37 - r)
  // Lander: 100 * w / (101.3 - 2.67123 * r)
  // O'Connor: w * (1 + 0.025 * r)
  
  static double calculateOneRm(double weight, int reps, OneRmFormula formula) {
    if (reps == 0) return 0.0;
    if (reps == 1) return weight;

    switch (formula) {
      case OneRmFormula.epley:
        return weight * (1 + reps / 30);
      case OneRmFormula.brzycki:
        if (reps >= 37) return weight; // Prevent division by zero/negative
        return weight * 36 / (37 - reps);
      case OneRmFormula.lander:
        return 100 * weight / (101.3 - 2.67123 * reps);
      case OneRmFormula.oconnor:
        return weight * (1 + 0.025 * reps);
      case OneRmFormula.average:
        double epley = weight * (1 + reps / 30);
        double brzycki = reps >= 37 ? weight : weight * 36 / (37 - reps);
        double lander = 100 * weight / (101.3 - 2.67123 * reps);
        double oconnor = weight * (1 + 0.025 * reps);
        return (epley + brzycki + lander + oconnor) / 4;
    }
  }

  // Calculate the highest 1RM from a list of sets
  static double getBestOneRm(List<SetEntry> sets, OneRmFormula formula) {
    double best = 0.0;
    for (var s in sets) {
      double current = calculateOneRm(s.weightKg, s.reps, formula);
      if (current > best) {
        best = current;
      }
    }
    return best;
  }

  // --- Volume ---
  static double calculateVolume(List<SetEntry> sets) {
    return sets.fold(0.0, (sum, set) => sum + (set.weightKg * set.reps));
  }

  // --- Muscle Recovery ---
  static double calculateRecoveryPercentage(DateTime? lastTrained, int fullRecoveryDays) {
    if (lastTrained == null) return 1.0; // Fully rested

    final now = DateTime.now();
    final difference = now.difference(lastTrained);
    
    // Total hours needed for full recovery
    final totalRecoveryHours = fullRecoveryDays * 24.0;
    
    if (difference.inHours >= totalRecoveryHours) {
      return 1.0; // 100% recovered
    }
    
    // Linear decay from 0.0 (just trained) to 1.0 (fully rested)
    return difference.inHours / totalRecoveryHours;
  }

  // --- Streaks & Rest Days ---
  static int calculateCurrentStreak(List<DateTime> sessionDates) {
    if (sessionDates.isEmpty) return 0;
    
    // Sort dates descending
    final sortedDates = sessionDates.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList();
    sortedDates.sort((a, b) => b.compareTo(a));

    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    
    int streak = 0;
    DateTime expectedDate = todayNormalized;

    // Check if the most recent session is today or yesterday
    if (sortedDates.isNotEmpty) {
      final mostRecent = sortedDates.first;
      final diff = todayNormalized.difference(mostRecent).inDays;
      if (diff > 1) {
        return 0; // Streak broken
      }
      if (diff == 1) {
        expectedDate = todayNormalized.subtract(const Duration(days: 1));
      }
    }

    for (final date in sortedDates) {
      if (date == expectedDate) {
        streak++;
        expectedDate = expectedDate.subtract(const Duration(days: 1));
      } else {
        break; // Gap found
      }
    }

    return streak;
  }

  static bool isRestDay(List<DateTime> sessionDates) {
    final today = DateTime.now();
    final todayNormalized = DateTime(today.year, today.month, today.day);
    
    for (final date in sessionDates) {
      if (DateTime(date.year, date.month, date.day) == todayNormalized) {
        return false; // Not a rest day if a session exists today
      }
    }
    return true; // Rest day if no sessions today
  }
}
