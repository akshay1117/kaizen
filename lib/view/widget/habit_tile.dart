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
    final progressAsync = ref.watch(habitProgressProvider((habit.id, date)));
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
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: progress > 0 ? () => ref.read(habitNotifierProvider.notifier).updateProgress(habit.id, date, progress - 1) : null,
                      ),
                      SizedBox(
                        width: 60,
                        child: Text('$progress / ${habit.targetValue}\n${habit.unit ?? ""}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => ref.read(habitNotifierProvider.notifier).updateProgress(habit.id, date, progress + 1),
                      ),
                    ]
                  );
                } else {
                  final completed = progress > 0;
                  return IconButton(
                    icon: Icon(completed ? Icons.check_circle : Icons.radio_button_unchecked, color: completed ? color : null),
                    onPressed: () => ref.read(habitNotifierProvider.notifier).updateProgress(habit.id, date, completed ? 0 : 1),
                  );
                }
              },
              loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator()),
              error: (_, __) => const Icon(Icons.error),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) async {
                if (value == 'delete') {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Habit'),
                      content: const Text('Are you sure you want to delete this habit and all its history?'),
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
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}