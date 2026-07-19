import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/model/database.dart';
import 'package:optimos/services/design_tokens.dart';

IconData getHabitIcon(String name) {
  switch (name) {
    case 'wallet': return Icons.account_balance_wallet_outlined;
    case 'moon': return Icons.nights_stay_outlined;
    case 'camera': return Icons.camera_alt_outlined;
    case 'coffee': return Icons.local_cafe_outlined;
    case 'fitness': return Icons.fitness_center_outlined;
    case 'book': return Icons.menu_book_outlined;
    case 'medication': return Icons.medication_outlined;
    case 'water': return Icons.water_drop_outlined;
    case 'favorite': return Icons.favorite_border;
    case 'restaurant': return Icons.restaurant_menu_outlined;
    case 'directions_run': return Icons.directions_run_outlined;
    case 'laptop': return Icons.laptop_mac_outlined;
    case 'show_chart': return Icons.show_chart;
    default: return Icons.favorite_border; // fallback
  }
}

/// A purely stateless, highly polished, reusable heatmap card component.
class HabitHeatmapCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color accentColor;
  final List<bool> completionData;
  final VoidCallback onCheckPressed;
  final VoidCallback? onLongPress;

  const HabitHeatmapCard({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.completionData,
    required this.onCheckPressed,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the current day (assumed to be the last item) is completed
    final bool isCompletedToday = completionData.isNotEmpty && completionData.last;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFF151515), // Deep dark grey/black
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Row
            Row(
              children: [
                // Leading Icon Button
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Icon(
                      icon, 
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Habit Title
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFFEEEEEE),
                        fontSize: 17.0,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'sans-serif',
                      ),
                    ),
                  ),
                ),
                // Trailing Checkmark Button
                GestureDetector(
                  onTap: onCheckPressed,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isCompletedToday ? accentColor.withValues(alpha: 0.2) : accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isCompletedToday ? accentColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: isCompletedToday
                        ? const Icon(Icons.check, size: 24, color: Colors.white)
                        : const SizedBox(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Bottom Heatmap Grid
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(54, (colIndex) {
                  const int rows = 7;
                  const double spacing = 2.5;
                  const double squareSize = 8.5;
                  
                  return Padding(
                    padding: EdgeInsets.only(right: colIndex < 53 ? spacing : 0),
                    child: Column(
                      children: List.generate(rows, (rowIndex) {
                        final int dataIndex = (colIndex * rows) + rowIndex;
                        
                        // Safety check to avoid index out of bounds
                        final bool isCompleted = dataIndex < completionData.length 
                            ? completionData[dataIndex] 
                            : false;

                        return Container(
                          width: squareSize,
                          height: squareSize,
                          margin: EdgeInsets.only(bottom: rowIndex < rows - 1 ? spacing : 0),
                          decoration: BoxDecoration(
                            color: isCompleted 
                                ? accentColor
                                : accentColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A connected wrapper that integrates the [HabitHeatmapCard] with Riverpod.
class ConnectedHabitHeatmapCard extends ConsumerWidget {
  final Habit habit;
  final DateTime today;

  const ConnectedHabitHeatmapCard({
    super.key,
    required this.habit,
    required this.today,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(int.parse(habit.color.replaceFirst('#', '0xFF')));
    final yearlyDataAsync = ref.watch(habitYearlyProgressProvider(habit.id));
    final progressAsync = ref.watch(habitProgressProvider((habit, today)));

    return yearlyDataAsync.when(
      data: (yearlyData) {
        const int totalDays = 54 * 7; // 378
        final DateTime startDay = today.subtract(const Duration(days: totalDays - 1));
        
        final List<bool> completionData = List.generate(totalDays, (index) {
          final date = startDay.add(Duration(days: index));
          final normalizedDate = DateTime(date.year, date.month, date.day);
          final int progress = yearlyData[normalizedDate] ?? 0;
          return habit.targetValue > 0 && progress >= habit.targetValue;
        });

        // Ensure we properly reflect the precise today's state from the daily progress provider.
        final bool isCompletedToday = progressAsync.asData?.value != null && 
                                      progressAsync.asData!.value >= habit.targetValue;
        if (completionData.isNotEmpty) {
           completionData.last = isCompletedToday;
        }

        return HabitHeatmapCard(
          title: habit.name,
          icon: getHabitIcon(habit.icon),
          accentColor: color,
          completionData: completionData,
          onCheckPressed: () {
            ref.read(habitNotifierProvider.notifier).toggleCompletion(habit, today, isCompletedToday);
          },
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
        );
      },
      loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: 120),
    );
  }
}
