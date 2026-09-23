import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class SetsTab extends StatelessWidget {
  const SetsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text(
          'My Workouts',
          style: theme.textTheme.displayMedium,
        ),
        const SizedBox(height: AppSpacing.lg),
        
        // Quick Actions
        _buildActionTile(context, Icons.add, 'New Workout...', 'e.g., Upper Body, Leg Day, Monday Routine'),
        _buildActionTile(context, Icons.auto_graph, 'New Custom Plan...', null),
        _buildActionTile(context, Icons.menu_book, 'My Exercises', null, trailingText: '24 >'),
        
        const SizedBox(height: AppSpacing.xl),
        
        // Templates Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Workout Templates', style: theme.textTheme.titleLarge),
            Icon(Icons.keyboard_arrow_down, color: isDark ? GymTheme.textSecondary : GymTheme.lightTextSecondary),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Templates Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.8,
          children: [
            _buildTemplateCard(context, 'Grow Your Upper Body', 'Incline Bench Press, Seated Cable Row...'),
            _buildTemplateCard(context, 'Burn Fat & Boost Endurance', 'Goblet Squat, Kettlebell Swing...'),
            _buildTemplateCard(context, 'Build Powerful Legs & Glutes', 'Barbell Lunge, Leg Press...'),
            _buildTemplateCard(context, 'Starting Strength', 'Squat, Bench Press, Overhead Press...'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(BuildContext context, IconData icon, String title, String? subtitle, {String? trailingText}) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle, style: theme.textTheme.bodyMedium),
                ],
              ],
            ),
          ),
          if (trailingText != null)
            Text(trailingText, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, String title, String subtitle) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? GymTheme.cardBackground : GymTheme.lightCardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
