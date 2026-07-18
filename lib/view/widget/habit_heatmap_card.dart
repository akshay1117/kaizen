import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/model/database.dart';
import 'package:optimos/services/design_tokens.dart';

class HabitHeatmapCard extends ConsumerWidget {
  final Habit habit;
  final DateTime today;

  const HabitHeatmapCard({
    super.key,
    required this.habit,
    required this.today,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Generate the last 21 days for the heatmap
    final List<DateTime> pastDays = List.generate(21, (index) {
      return today.subtract(Duration(days: 20 - index));
    });

    final color = Color(int.parse(habit.color.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onLongPress: () async {
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            backgroundColor: DesignTokens.bgSecondary,
            title: const Text('Delete Habit', style: TextStyle(color: Colors.white)),
            content: Text('Are you sure you want to delete "${habit.name}"?', style: const TextStyle(color: Colors.white70)),
            actions: [
              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Cancel')),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        );
        if (confirm == true) {
          ref.read(habitNotifierProvider.notifier).deleteHabit(habit.id);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: DesignTokens.bgSecondary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
          border: Border.all(color: DesignTokens.borderPrimary, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    // Fallback icon for now, ideally parsed from name
                    child: Icon(
                      Icons.favorite, // We could map the string back to IconData if we had a registry
                      color: color,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.name,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: DesignTokens.textPrimary,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        habit.categories ?? 'No category',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: DesignTokens.textSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
                // Check button for today
                _buildTodayCheckButton(context, ref, color),
              ],
            ),
            const SizedBox(height: 24),
            // Heatmap grid
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: pastDays.map((date) {
                return _HeatmapSquare(
                  habitId: habit.id,
                  date: date,
                  accentColor: color,
                  targetValue: habit.targetValue,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayCheckButton(BuildContext context, WidgetRef ref, Color color) {
    final progressAsync = ref.watch(habitProgressProvider((habit.id, today)));

    return progressAsync.when(
      data: (progress) {
        final completed = progress >= habit.targetValue;
        return GestureDetector(
          onTap: () {
            ref.read(habitNotifierProvider.notifier).toggleCompletion(habit.id, today, completed);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: completed ? color : Colors.transparent,
              border: Border.all(
                color: completed ? color : DesignTokens.borderSecondary,
                width: 2,
              ),
              shape: BoxShape.circle,
            ),
            child: completed
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null,
          ),
        );
      },
      loading: () => const SizedBox(width: 32, height: 32, child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(width: 32, height: 32),
    );
  }
}

class _HeatmapSquare extends ConsumerWidget {
  final String habitId;
  final DateTime date;
  final Color accentColor;
  final int targetValue;

  const _HeatmapSquare({
    required this.habitId,
    required this.date,
    required this.accentColor,
    required this.targetValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(habitProgressProvider((habitId, date)));
    
    return progressAsync.when(
      data: (progress) {
        final double ratio = targetValue > 0 ? (progress / targetValue).clamp(0.0, 1.0) : 0;
        final bool isCompleted = ratio > 0;
        
        return Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: isCompleted 
                ? accentColor.withValues(alpha: ratio)
                : DesignTokens.bgTertiary,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
      loading: () => _buildEmptySquare(),
      error: (_, __) => _buildEmptySquare(),
    );
  }

  Widget _buildEmptySquare() {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: DesignTokens.bgTertiary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
