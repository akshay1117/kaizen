import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

class MuscleRecoveryDiagram extends StatelessWidget {
  final Map<MuscleGroup, double> recoveryData; // 0.0 (just trained) to 1.0 (rested)

  const MuscleRecoveryDiagram({
    super.key,
    required this.recoveryData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: GymTheme.cardBackground.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: MuscleGroup.values.map((muscle) {
            final recovery = recoveryData[muscle] ?? 1.0;
            return _buildMuscleIndicator(context, muscle.name, recovery);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMuscleIndicator(BuildContext context, String name, double recovery) {
    final color = Color.lerp(
      GymTheme.muscleJustTrained,
      GymTheme.muscleRested,
      recovery,
    )!;

    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: GymTheme.muscleRested, end: color),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      builder: (context, animatedColor, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: animatedColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
