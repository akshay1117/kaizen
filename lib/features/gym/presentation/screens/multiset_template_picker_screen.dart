import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class MultisetTemplatePickerScreen extends ConsumerWidget {
  final String workoutName;

  const MultisetTemplatePickerScreen({
    super.key,
    required this.workoutName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        leading: const SizedBox.shrink(), // hide back button, use Checkmark

        title: Text('Add to "$workoutName"', style: const TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: GymTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Choose Template',
            style: TextStyle(color: GymTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildTemplateCard(
            context,
            icon: Icons.layers,
            title: 'Superset',
            description: 'Two or more exercises performed back-to-back with no rest in between.',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTemplateCard(
            context,
            icon: Icons.arrow_drop_down_circle_outlined,
            title: 'Dropset',
            description: 'Perform an exercise to failure, reduce the weight, and continue to failure again.',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTemplateCard(
            context,
            icon: Icons.checklist,
            title: 'Checkmark',
            description: 'A sequence of exercises where you check off each set as you go.',
            onTap: () {},
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTemplateCard(
            context,
            icon: Icons.build,
            title: 'Custom',
            description: 'Build your own multiset with custom rest times and logging options.',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, {required IconData icon, required String title, required String description, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GymTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: GymTheme.pillUnselected),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: GymTheme.primaryAccent, size: 28),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(description, style: const TextStyle(color: GymTheme.textSecondary, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
          ],
        ),
      ),
    );
  }
}
