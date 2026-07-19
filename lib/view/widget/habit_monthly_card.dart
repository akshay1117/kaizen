import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/model/database.dart';
import 'package:optimos/services/design_tokens.dart';

class HabitMonthlyCard extends StatelessWidget {
  final String title;
  final Color accentColor;
  final bool isCompletedToday;
  final VoidCallback onToggleToday;
  final List<bool> completionData; // Length 35
  final String monthYear;

  const HabitMonthlyCard({
    super.key,
    required this.title,
    required this.accentColor,
    required this.isCompletedToday,
    required this.onToggleToday,
    required this.completionData,
    required this.monthYear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignTokens.borderSecondary.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              GestureDetector(
                onTap: onToggleToday,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isCompletedToday ? accentColor.withValues(alpha: 0.2) : accentColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isCompletedToday ? accentColor : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isCompletedToday ? Icons.check : Icons.add,
                      color: isCompletedToday ? accentColor : Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      monthYear,
                      style: const TextStyle(
                        color: DesignTokens.textTertiary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // 35-day grid
          LayoutBuilder(
            builder: (context, constraints) {
              const double spacing = 3.0;
              // 7 columns. Total spacing = 6 * spacing
              final double dotSize = (constraints.maxWidth - (6 * spacing)) / 7;
              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: List.generate(35, (index) {
                  final isCompleted = completionData[index];
                  return Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: isCompleted ? accentColor : accentColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ConnectedHabitMonthlyCard extends ConsumerWidget {
  final Habit habit;
  final DateTime today;

  const ConnectedHabitMonthlyCard({
    super.key,
    required this.habit,
    required this.today,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(habit.color.replaceFirst('#', '0xFF')));
    final yearlyDataAsync = ref.watch(habitYearlyProgressProvider(habit.id));
    final monthYear = DateFormat('MMM yyyy').format(today);
    
    // Last 35 days ending on today
    final List<DateTime> last35Days = List.generate(35, (index) {
      return today.subtract(Duration(days: 34 - index));
    });

    return yearlyDataAsync.when(
      data: (yearlyData) {
        final List<bool> completionData = last35Days.map((date) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final int progress = yearlyData[normalizedDate] ?? 0;
          return habit.targetValue > 0 && progress >= habit.targetValue;
        }).toList();

        // Ensure today is accurate if there's a live update happening
        final progressAsync = ref.read(habitProgressProvider((habit, today)));
        bool isCompletedToday = completionData[34];
        if (progressAsync.asData?.value != null) {
          isCompletedToday = progressAsync.asData!.value >= habit.targetValue;
          completionData[34] = isCompletedToday;
        }

        return HabitMonthlyCard(
          title: habit.name,
          accentColor: color,
          isCompletedToday: isCompletedToday,
          monthYear: monthYear,
          completionData: completionData,
          onToggleToday: () {
            ref.read(habitNotifierProvider.notifier).toggleCompletion(habit, today, isCompletedToday);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
    );
  }
}
