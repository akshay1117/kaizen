import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/presentation/widgets/empty_state_widget.dart';

class SessionsTab extends StatelessWidget {
  const SessionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Sessions',
            style: theme.textTheme.displayMedium,
          ),
        ),
        const Expanded(
          child: EmptyStateWidget(
            icon: Icons.timer_off_outlined,
            title: 'No Sessions Yet',
            message: 'Complete a workout session to see your history here.',
          ),
        ),
      ],
    );
  }
}
