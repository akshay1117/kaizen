import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class BodyScreen extends ConsumerWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        title:
            const Text('Body', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: GymTheme.textPrimary),
            onPressed: () {
              // Body Settings
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildWeightRow(),
          const SizedBox(height: 24),
          _buildLegend(),
          const SizedBox(height: 16),
          _buildMuscleMapPlaceholder(),
          const SizedBox(height: 24),
          _buildMuscleList(),
        ],
      ),
    );
  }

  Widget _buildWeightRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
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
              const SizedBox(width: 8),
              const Icon(Icons.show_chart,
                  color: GymTheme.primaryAccent, size: 20),
              const SizedBox(width: 8),
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
        SizedBox(width: 16),
        Icon(Icons.circle, color: GymTheme.textSecondary, size: 12),
        SizedBox(width: 6),
        Text('Rested',
            style: TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
      ],
    );
  }

  Widget _buildMuscleMapPlaceholder() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.accessibility_new,
                size: 100, color: GymTheme.textSecondary),
            SizedBox(height: 16),
            Text('Muscle Map SVG Area',
                style: TextStyle(color: GymTheme.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleList() {
    return Container(
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMuscleRow('Chest', true, '2h ago'),
          const Divider(color: GymTheme.pillUnselected, height: 1),
          _buildMuscleRow('Back', false, '3d ago'),
          const Divider(color: GymTheme.pillUnselected, height: 1),
          _buildMuscleRow('Legs', false, '5d ago'),
        ],
      ),
    );
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
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
        ],
      ),
      onTap: () {}, // Navigate to muscle group summary
    );
  }
}
