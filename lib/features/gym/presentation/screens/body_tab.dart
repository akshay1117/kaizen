import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class BodyTab extends StatelessWidget {
  const BodyTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Body Recovery', style: theme.textTheme.displayMedium),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {}, // Open body settings modal
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          height: 300,
          color: Colors.grey.withValues(alpha: 0.1),
          child: const Center(
            child: Text('Anatomical Muscle Diagram Placeholder'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        const ListTile(
          title: Text('Chest'),
          trailing: Text('1 min, 26 secs ago'),
        ),
        const ListTile(
          title: Text('Shoulders'),
          trailing: Text('1 min, 27 secs ago'),
        ),
      ],
    );
  }
}
