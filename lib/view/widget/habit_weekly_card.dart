import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/model/database.dart';
import 'package:optimos/services/design_tokens.dart';
import 'package:optimos/view/widget/habit_heatmap_card.dart'; // for getHabitIcon

class HabitWeeklyCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<bool> completionData; // Length 5
  final List<DateTime> days;
  final Function(int, bool) onToggleDay;
  
  const HabitWeeklyCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.completionData,
    required this.days,
    required this.onToggleDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: const Color(0xFF151515),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: DesignTokens.borderSecondary.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        children: [
          // Icon Box
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          // Title Box
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFFEEEEEE),
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(width: 12),
          
          // 5 Day Checkboxes
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(5, (index) {
              final isCompleted = completionData[index];
              return GestureDetector(
                onTap: () => onToggleDay(index, isCompleted),
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isCompleted ? accentColor.withValues(alpha: 0.2) : accentColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isCompleted ? accentColor : accentColor.withValues(alpha: 0.2),
                      width: 1.5,
                    ),
                  ),
                  child: isCompleted
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class ConnectedHabitWeeklyCard extends ConsumerWidget {
  final Habit habit;
  final DateTime today;

  const ConnectedHabitWeeklyCard({
    super.key,
    required this.habit,
    required this.today,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(habit.color.replaceFirst('#', '0xFF')));
    final yearlyDataAsync = ref.watch(habitYearlyProgressProvider(habit.id));
    
    // Generate the last 5 days including today
    final List<DateTime> last5Days = List.generate(5, (index) {
      return today.subtract(Duration(days: 4 - index));
    });

    return yearlyDataAsync.when(
      data: (yearlyData) {
        final List<bool> completionData = last5Days.map((date) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final int progress = yearlyData[normalizedDate] ?? 0;
          return habit.targetValue > 0 && progress >= habit.targetValue;
        }).toList();

        // Ensure today is accurate if there's a live update happening
        final progressAsync = ref.read(habitProgressProvider((habit, today)));
        if (progressAsync.asData?.value != null) {
          completionData[4] = progressAsync.asData!.value >= habit.targetValue;
        }

        return HabitWeeklyCard(
          title: habit.name,
          icon: getHabitIcon(habit.icon),
          accentColor: color,
          completionData: completionData,
          days: last5Days,
          onToggleDay: (index, isCurrentlyCompleted) {
            final date = last5Days[index];
            ref.read(habitNotifierProvider.notifier).toggleCompletion(habit, date, isCurrentlyCompleted);
          },
        );
      },
      loading: () => const SizedBox(height: 70, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: 70),
    );
  }
}
