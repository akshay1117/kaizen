import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/model/database.dart';

class HabitTile extends ConsumerWidget {
  final Habit habit;
  final DateTime date;

  const HabitTile({super.key, required this.habit, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(habitProgressProvider((habit, date)));
    final color = Color(int.parse(habit.color.replaceFirst('#', '0xFF')));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Text(habit.icon, style: const TextStyle(fontSize: 28)),
        title: Text(habit.name),
        subtitle: Text('Streak: ${habit.currentStreak} days'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            progressAsync.when(
              data: (progress) {
                if (habit.isQuantitative) {
                  final completed = progress >= habit.targetValue;
                  if (completed) {
                    return IconButton(
                      icon: Icon(Icons.check_circle, color: color),
                      onPressed: () => ref.read(habitNotifierProvider.notifier).updateProgress(habit.id, date, progress - 1),
                    );
                  }

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: progress > 0 ? () => ref.read(habitNotifierProvider.notifier).updateProgress(habit.id, date, progress - 1) : null,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('$progress / ${habit.targetValue}\n${habit.unit ?? ""}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => ref.read(habitNotifierProvider.notifier).updateProgress(habit.id, date, progress + 1),
                      ),
                    ]
                  );
                } else {
                  final completed = progress > 0;
                  return IconButton(
                    icon: Icon(completed ? Icons.check_circle : Icons.radio_button_unchecked, color: completed ? color : null),
                    onPressed: () {
                      ref.read(habitNotifierProvider.notifier).toggleCompletion(habit, date, completed);
                    },
                  );
                }
              },
              loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
              error: (_, __) => const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}