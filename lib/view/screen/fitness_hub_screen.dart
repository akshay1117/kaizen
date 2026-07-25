import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaizen/services/design_tokens.dart';

class FitnessHubScreen extends StatelessWidget {
  const FitnessHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Hub')),
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
              color: DesignTokens.accentGym,
              onTap: () => context.pushNamed('gym'),
            ),
            _buildModuleCard(
              context,
              icon: '🥊',
              title: 'Boxing',
              color: DesignTokens.accentBoxing,
              onTap: () => context.pushNamed('boxing'),
            ),
            _buildModuleCard(
              context,
              icon: '🏃',
              title: 'Running',
              color: DesignTokens.accentRun,
              onTap: () => context.pushNamed('running'),
            ),
            _buildModuleCard(
              context,
              icon: '🥗',
              title: 'Diet',
              color: DesignTokens.accentDiet,
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
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: BorderSide(color: color.withValues(alpha: 0.3), width: 1),
      ),
      elevation: 0,
      color: DesignTokens.bgSecondary,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: DesignTokens.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}