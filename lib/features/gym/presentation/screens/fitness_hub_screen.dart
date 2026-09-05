import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:go_router/go_router.dart';


class FitnessHubScreen extends StatelessWidget {
  const FitnessHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      appBar: const GlassAppBar(title: Text('Fitness Hub')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
          children: [
            _buildModuleCard(
              context,
              icon: '🏋️',
              title: 'Gym',
              color: AppColors.accentViolet,
              onTap: () => context.pushNamed('gym'),
            ),
            _buildModuleCard(
              context,
              icon: '🥊',
              title: 'Boxing',
              color: AppColors.semanticUrgent,
              onTap: () => context.pushNamed('boxing'),
            ),
            _buildModuleCard(
              context,
              icon: '🏃',
              title: 'Running',
              color: AppColors.accentNeon,
              onTap: () => context.pushNamed('running'),
            ),
            _buildModuleCard(
              context,
              icon: '🥗',
              title: 'Diet',
              color: AppColors.accentVelvet,
              onTap: () => context.pushNamed('diet'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModuleCard(BuildContext context,
      {required String icon, required String title, required Color color, required VoidCallback onTap}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
      ),

      color: AppColors.surfaceElevatedLow,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}