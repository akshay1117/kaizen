import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/model/database.dart';
import 'package:kaizen/controller/habit_stats_provider.dart';
import 'package:kaizen/services/design_tokens.dart';
import 'package:kaizen/utils/icon_utils.dart';
import 'package:go_router/go_router.dart';

class HabitDetailScreen extends ConsumerWidget {
  final Habit habit;

  const HabitDetailScreen({super.key, required this.habit});

  Color _parseColor(String hexStr) {
    hexStr = hexStr.toUpperCase().replaceAll("#", "");
    if (hexStr.length == 6) {
      hexStr = "FF$hexStr";
    }
    return Color(int.tryParse(hexStr, radix: 16) ?? 0xFFFFFFFF);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitColor = _parseColor(habit.color);
    final statsAsync = ref.watch(habitStatsProvider(habit));

    return GlassScaffold(
      backgroundColor: DesignTokens.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    label: const Text('Habits', style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                  Text(
                    habit.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to edit screen (to be implemented)
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2C2E),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Edit', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Section
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: habitColor.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            getHabitIcon(habit.icon),
                            color: habitColor,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                habit.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    habit.frequency == 'daily' ? 'Every day' : habit.frequency,
                                    style: const TextStyle(color: DesignTokens.textSecondary, fontSize: 14),
                                  ),
                                  if (habit.reminderTime != null) ...[
                                    const SizedBox(width: 8),
                                    const Text('·', style: TextStyle(color: DesignTokens.textSecondary)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.alarm, color: DesignTokens.textSecondary, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      habit.reminderTime!,
                                      style: const TextStyle(color: DesignTokens.textSecondary, fontSize: 14),
                                    ),
                                  ]
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Content loaded from provider
                    statsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                      data: (stats) {
                        final totalCheckIns = stats['totalCheckIns'] as int;
                        final bestStreak = stats['bestStreak'] as int;
                        final completionRate = stats['completionRate'] as int;
                        final heatmapData = stats['heatmapData'] as Map<DateTime, int>;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Streaks Row
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.local_fire_department,
                                    iconColor: Colors.orange,
                                    value: '${habit.currentStreak}',
                                    label: 'Current streak',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    icon: Icons.emoji_events,
                                    iconColor: Colors.amber,
                                    value: '$bestStreak',
                                    label: 'Best streak',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Consistency Heatmap
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Consistency',
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        'Last 365 days',
                                        style: TextStyle(color: DesignTokens.textSecondary.withValues(alpha: 0.5), fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  _ConsistencyHeatmap(heatmapData: heatmapData, habitColor: habitColor),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Total / Completion Row
                            Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    value: '$totalCheckIns',
                                    label: 'Total check-ins',
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _StatCard(
                                    value: '$completionRate%',
                                    label: 'Completion rate',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String value;
  final String label;

  const _StatCard({
    this.icon,
    this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
          ],
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: DesignTokens.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsistencyHeatmap extends StatelessWidget {
  final Map<DateTime, int> heatmapData;
  final Color habitColor;

  const _ConsistencyHeatmap({required this.heatmapData, required this.habitColor});

  @override
  Widget build(BuildContext context) {
    // Generate the last 54 weeks of dates
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    // Find the Sunday of the current week (or Saturday depending on week start)
    // Let's start week on Monday. So end date is the upcoming Sunday.
    final int daysToSunday = DateTime.sunday - today.weekday;
    final DateTime endSunday = today.add(Duration(days: daysToSunday));
    
    const int numWeeks = 54;
    const int numDays = numWeeks * 7;
    final DateTime startDate = endSunday.subtract(const Duration(days: numDays - 1));

    return SizedBox(
      height: 140, // 7 rows of 14px boxes + 6px margins
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true, // Scroll to the right (most recent) by default
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(numWeeks, (weekIndex) {
            return Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Column(
                children: List.generate(7, (dayIndex) {
                  final int dayOffset = (weekIndex * 7) + dayIndex;
                  final DateTime date = startDate.add(Duration(days: dayOffset));
                  
                  final bool isCompleted = heatmapData.containsKey(date);
                  final bool isFuture = date.isAfter(today);

                  return Container(
                    width: 14,
                    height: 14,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      color: isFuture 
                          ? Colors.transparent 
                          : isCompleted 
                              ? habitColor 
                              : const Color(0xFF2C2C2E), // Uncompleted dark grey
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            );
          }),
        ),
      ),
    );
  }
}
