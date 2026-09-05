import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

class ExerciseListTile extends StatelessWidget {
  final Exercise exercise;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;

  const ExerciseListTile({
    super.key,
    required this.exercise,
    required this.onTap,
    this.isSelected = false,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      splashFactory: InkRipple.splashFactory,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: theme.textTheme.bodyLarge,
                  ),
                  if (exercise.primaryMuscles.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        exercise.primaryMuscles.map((m) => m.name).join(', '),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),
            if (isSelectionMode)
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? theme.primaryColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? theme.primaryColor : (isDark ? GymTheme.textSecondary : GymTheme.lightTextSecondary),
                    width: 2,
                  ),
                ),
                child: AnimatedScale(
                  scale: isSelected ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutBack,
                  child: const Icon(Icons.check, size: 16, color: AppColors.textPrimary),
                ),
              )
            else
              Icon(
                Icons.chevron_right,
                color: isDark ? GymTheme.textSecondary : GymTheme.lightTextSecondary,
              ),
          ],
        ),
      ),
    );
  }
}
