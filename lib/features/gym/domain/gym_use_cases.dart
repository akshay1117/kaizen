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
  static bool isJustTrained(DateTime lastTrained, int fullRecoveryDays) {
    final now = DateTime.now();
    final difference = now.difference(lastTrained);
    return difference.inDays < fullRecoveryDays;
  }
}
