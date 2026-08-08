import 'package:flutter/material.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Today', style: theme.textTheme.displayMedium),
        const SizedBox(height: 16),
        // Horizontal calendar strip mock
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              return Container(
                width: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: index == 3 ? theme.primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('${index + 24}')),
              );
            },
          ),
        ),
        const SizedBox(height: 24),
        // Metrics mock
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetric(context, 'Sets', '4'),
            _buildMetric(context, 'Repetitions', '48'),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMetric(context, 'Volume', '1080 kg'),
            _buildMetric(context, 'Avg Rest', '18s'),
          ],
        ),
      ],
    );
  }

  Widget _buildMetric(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}
