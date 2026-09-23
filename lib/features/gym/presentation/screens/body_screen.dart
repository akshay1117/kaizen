import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:kaizen/features/gym/presentation/widgets/muscle_map_diagram.dart';

class BodyScreen extends ConsumerWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassScaffold(
        backgroundColor: GymTheme.background,
        body: SafeArea(
          child: Column(children: [
            // Custom Top Bar (moved beneath SafeArea)
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Body',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: GymTheme.textPrimary)),
                  IconButton(
                    icon:
                        const Icon(Icons.settings, color: GymTheme.textPrimary),
                    onPressed: () {
                      // Body Settings
                    },
                  ),
                ],
              ),
            ),
            Expanded(
                child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildWeightRow(),
                const SizedBox(height: AppSpacing.lg),
                _buildLegend(),
                const SizedBox(height: AppSpacing.md),
                _buildMuscleMap(ref),
                const SizedBox(height: AppSpacing.lg),
                _buildMuscleList(ref),
              ],
            ))
          ]),
        ));
  }

  Widget _buildWeightRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Weight',
              style: TextStyle(
                  color: GymTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          Row(
            children: [
              const Text('75.0 kg',
                  style: TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.show_chart,
                  color: GymTheme.primaryAccent, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text('Goal: 80 kg',
                  style: TextStyle(
                      color: GymTheme.textSecondary.withValues(alpha: 0.7),
                      fontSize: 13)),
              const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.circle, color: GymTheme.destructive, size: 12),
        SizedBox(width: 6),
        Text('Just Trained',
            style: TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
        SizedBox(width: AppSpacing.md),
        Icon(Icons.circle, color: GymTheme.textSecondary, size: 12),
        SizedBox(width: 6),
        Text('Rested',
            style: TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _buildMuscleMap(WidgetRef ref) {
    final recovery = ref.watch(muscleRecoveryProvider);
    return MuscleMapDiagram(
      recovery: recovery,
      width: double.infinity,
      height: 350,
    );
  }

  Widget _buildMuscleList(WidgetRef ref) {
    final lastTrained = ref.watch(muscleLastTrainedProvider);
    final recovery = ref.watch(muscleRecoveryProvider);

    if (lastTrained.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: GymTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: const Center(
          child: Text('No muscles trained yet.',
              style: TextStyle(color: GymTheme.textSecondary)),
        ),
      );
    }

    final sortedMuscles = lastTrained.keys.toList()
      ..sort((a, b) => lastTrained[b]!.compareTo(lastTrained[a]!));

    return Container(
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        children: sortedMuscles.map((muscle) {
          final isLast = muscle == sortedMuscles.last;
          final time = lastTrained[muscle]!;
          final timeAgo = _formatTimeAgo(time);
          final rec = recovery[muscle] ?? 1.0;
          final justTrained = rec < 0.3; // arbitrary threshold for UI

          return Column(
            children: [
              _buildMuscleRow(muscle.name.toUpperCase(), justTrained, timeAgo),
              if (!isLast)
                const Divider(color: GymTheme.pillUnselected, height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  Widget _buildMuscleRow(String name, bool justTrained, String timeAgo) {
    return ListTile(
      leading: Icon(
        Icons.circle,
        color: justTrained ? GymTheme.destructive : GymTheme.textSecondary,
        size: 14,
      ),
      title: Text(name, style: const TextStyle(color: GymTheme.textPrimary)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(timeAgo,
              style:
                  const TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
          const SizedBox(width: AppSpacing.sm),
          const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
        ],
      ),
      onTap: () {}, // Navigate to muscle group summary
    );
  }
}
