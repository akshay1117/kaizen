import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/view/widget/habit_tile.dart';

class HabitsHomeScreen extends ConsumerStatefulWidget {
  const HabitsHomeScreen({super.key});

  @override
  ConsumerState<HabitsHomeScreen> createState() => _HabitsHomeScreenState();
}

class _HabitsHomeScreenState extends ConsumerState<HabitsHomeScreen> {
  bool _isEditing = false;
  final Set<String> _selectedHabits = {};
  DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final isToday = _selectedDate.isAtSameMomentAs(today);
    final habitsAsync = ref.watch(activeHabitsProvider(_selectedDate));

    return Scaffold(
      appBar: AppBar(
        leading: _isEditing
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                    _selectedHabits.clear();
                  });
                },
              )
            : PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (val) {
                  if (val == 'edit') {
                    setState(() {
                      _isEditing = true;
                    });
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit / Bulk Delete')),
                ],
              ),
        title: Text(_isEditing ? '${_selectedHabits.length} Selected' : 'Habits'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _selectedHabits.isEmpty
                  ? null
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Bulk Delete'),
                          content: Text('Are you sure you want to delete ${_selectedHabits.length} habits?'),
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
                        for (final id in _selectedHabits) {
                          await ref.read(habitNotifierProvider.notifier).deleteHabit(id);
                        }
                        if (mounted) {
                          setState(() {
                            _isEditing = false;
                            _selectedHabits.clear();
                          });
                        }
                      }
                    },
            )
          else
            IconButton(onPressed: () => context.pushNamed('add-habit'), icon: const Icon(Icons.add)),
        ],
      ),
      body: habitsAsync.when(
        data: (habits) {
          return Column(
            children: [
              if (!_isEditing) const WeeklyReportWidget(),
              if (!_isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left),
                        onPressed: () {
                          setState(() {
                            _selectedDate = _selectedDate.subtract(const Duration(days: 1));
                          });
                        },
                      ),
                      Text(
                        isToday
                            ? 'Today'
                            : '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right),
                        onPressed: isToday
                            ? null
                            : () {
                                setState(() {
                                  _selectedDate = _selectedDate.add(const Duration(days: 1));
                                });
                              },
                      ),
                    ],
                  ),
                ),
              if (!_isEditing) const Divider(),
              if (habits.isEmpty)
                const Expanded(
                  child: Center(child: Text('No habits yet. Tap + to add one.')),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: habits.length,
                    itemBuilder: (ctx, i) {
                      final habit = habits[i];
                      Widget tile = HabitTile(habit: habit, date: _selectedDate);

                      if (_isEditing) {
                        return Row(
                          children: [
                            Checkbox(
                              value: _selectedHabits.contains(habit.id),
                              onChanged: (bool? val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedHabits.add(habit.id);
                                  } else {
                                    _selectedHabits.remove(habit.id);
                                  }
                                });
                              },
                            ),
                            Expanded(child: tile),
                          ],
                        );
                      }

                      return SwipeToReveal(
                        onDelete: () async {
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
                        },
                        child: tile,
                      );
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class SwipeToReveal extends StatefulWidget {
  final Widget child;
  final VoidCallback onDelete;

  const SwipeToReveal({super.key, required this.child, required this.onDelete});

  @override
  State<SwipeToReveal> createState() => _SwipeToRevealState();
}

class _SwipeToRevealState extends State<SwipeToReveal> {
  double _dragExtent = 0.0;
  final double _actionWidth = 80.0;

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta ?? 0;
      if (_dragExtent > 0) _dragExtent = 0; // Prevent swiping right
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_dragExtent < -_actionWidth * 1.5) {
      // Swiped far enough -> Trigger delete (double swipe effect)
      setState(() => _dragExtent = 0);
      widget.onDelete();
    } else if (_dragExtent < -_actionWidth / 2) {
      // Swiped enough to reveal
      setState(() => _dragExtent = -_actionWidth);
    } else {
      // Didn't swipe enough, close
      setState(() => _dragExtent = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  setState(() => _dragExtent = 0);
                  widget.onDelete();
                },
                child: Container(
                  width: _actionWidth,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(_dragExtent, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

class WeeklyReportWidget extends ConsumerWidget {
  const WeeklyReportWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(weeklyReportProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return reportAsync.when(
      data: (report) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final date = today.subtract(Duration(days: 6 - index));
              final count = report[date] ?? 0;
              final isToday = index == 6;
              
              return Column(
                children: [
                  Text(
                    '${date.day}/${date.month}', 
                    style: TextStyle(fontSize: 12, fontWeight: isToday ? FontWeight.bold : FontWeight.normal)
                  ),
                  const SizedBox(height: 8),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: count > 0 ? Theme.of(context).colorScheme.primary : Colors.grey[800],
                    child: Text(count.toString(), style: TextStyle(fontSize: 12, color: count > 0 ? Colors.white : Colors.grey)),
                  )
                ]
              );
            })
          ),
        );
      },
      loading: () => const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator())),
      error: (e, _) => Padding(padding: const EdgeInsets.all(16.0), child: Text('Error: $e')),
    );
  }
}