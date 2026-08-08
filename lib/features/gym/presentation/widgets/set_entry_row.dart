import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

class SetEntryRow extends StatelessWidget {
  final int setNumber;
  final String? previousData; // e.g., "12 rep  20 kg"
  final SetEntry? currentEntry;
  final VoidCallback onTap;
  final VoidCallback onSwipeDelete;

  const SetEntryRow({
    super.key,
    required this.setNumber,
    this.previousData,
    this.currentEntry,
    required this.onTap,
    required this.onSwipeDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String weightText = currentEntry?.weightKg != null ? currentEntry!.weightKg.toStringAsFixed(1) : '-';
    final String repsText = currentEntry?.reps != null ? currentEntry!.reps.toString() : '-';

    return Dismissible(
      key: ValueKey('set_$setNumber'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onSwipeDelete(),
      background: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Set Number
              SizedBox(
                width: 32,
                child: Text(
                  '$setNumber',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? GymTheme.textSecondary : GymTheme.lightTextSecondary,
                  ),
                ),
              ),
              
              // Previous Data
              Expanded(
                child: Text(
                  previousData ?? '-',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? GymTheme.textSecondary.withValues(alpha: 0.5) : GymTheme.lightTextSecondary.withValues(alpha: 0.5),
                  ),
                ),
              ),

              // Active Inputs
              Row(
                children: [
                  _buildInputBox(context, '$weightText kg'),
                  const SizedBox(width: 8),
                  _buildInputBox(context, repsText),
                  const SizedBox(width: 8),
                  Icon(Icons.check_circle_outline, color: theme.primaryColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputBox(BuildContext context, String text) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? GymTheme.cardBackground : GymTheme.lightCardBackground,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GymTheme.tabularStyle(
          theme.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
