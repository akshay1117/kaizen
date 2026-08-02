import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaizen/controller/habit_providers.dart';
import 'package:kaizen/model/database.dart';
import 'package:kaizen/services/design_tokens.dart';
import 'package:kaizen/view/widget/custom_bottom_nav_bar.dart';
import 'package:kaizen/utils/habit_icons.dart';
import 'package:kaizen/view/screen/habit_detail_screen.dart';

class HabitsHomeScreen extends ConsumerStatefulWidget {
  const HabitsHomeScreen({super.key});

  @override
  ConsumerState<HabitsHomeScreen> createState() => _HabitsHomeScreenState();
}

class _HabitsHomeScreenState extends ConsumerState<HabitsHomeScreen> {
  DateTime _selectedDate = DateTime.now();
  int _navIndex = 0; // 0: Today, 1: Habits
  bool _isNavBarVisible = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider(_selectedDate));

    return GlassScaffold(
      backgroundColor: DesignTokens.bgPrimary,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: habitsAsync.when(
              data: (allHabits) {
                if (allHabits.isEmpty) {
                  return Center(
                    child: Text(
                      'No habits found. Tap + to create one.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  );
                }

                if (_navIndex == 0) {
                  return _buildTodayView(context, ref, allHabits);
                } else {
                  return _buildHabitsView(context, ref, allHabits);
                }
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: _isNavBarVisible ? 0 : -200, // Hide below screen completely
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! > 5) {
                  setState(() => _isNavBarVisible = false); // Swipe down to hide
                }
              },
              child: CustomBottomNavBar(
                selectedIndex: _navIndex,
                onItemSelected: (index) {
                  setState(() {
                    _navIndex = index;
                    _isNavBarVisible = false; // Hide after selection
                  });
                },
              ),
            ),
          ),
          
          // Drag handle at the bottom to reveal nav bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            left: 0,
            right: 0,
            bottom: _isNavBarVisible ? -100 : 0, // Hide when nav bar is visible
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.primaryDelta! < -5) {
                  setState(() => _isNavBarVisible = true); // Swipe up to reveal
                }
              },
              onTap: () {
                setState(() => _isNavBarVisible = true);
              },
              child: Container(
                height: 40,
                color: Colors.transparent, // expanded hit area
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => context.pushNamed('add-habit'),
              backgroundColor: DesignTokens.accentHabit,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayView(BuildContext context, WidgetRef ref, List<Habit> filteredHabits) {
    return RefreshIndicator(
      onRefresh: () async {
        // Just triggering a rebuild for now
        setState(() {});
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24),
              child: Text(
                'Today',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final habit = filteredHabits[index];
                  return Dismissible(
                    key: Key(habit.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      ref.read(habitNotifierProvider.notifier).deleteHabit(habit.id);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Column(
                      children: [
                        _TodayHabitItem(habit: habit, date: _selectedDate),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFF2A2A2A),
                          indent: 60,
                        ),
                      ],
                    ),
                  );
                },
                childCount: filteredHabits.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitsView(BuildContext context, WidgetRef ref, List<Habit> filteredHabits) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, top: 24, bottom: 24),
              child: Text(
                'Habits',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
            sliver: SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E), // Dark theme grouped background
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    ...List.generate(filteredHabits.length, (index) {
                      final habit = filteredHabits[index];
                      
                      String frequencyText = 'Every day';
                      if (habit.frequency != 'daily') {
                        frequencyText = habit.frequency;
                      }

                      return Dismissible(
                        key: Key(habit.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          ref.read(habitNotifierProvider.notifier).deleteHabit(habit.id);
                        },
                        background: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.vertical(
                              top: index == 0 ? const Radius.circular(24) : Radius.zero,
                              bottom: index == filteredHabits.length - 1 ? const Radius.circular(24) : Radius.zero,
                            ),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HabitDetailScreen(habit: habit),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.vertical(
                                top: index == 0 ? const Radius.circular(24) : Radius.zero,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                child: Row(
                                  children: [
                                    _buildIconWidget(habit.icon, _parseColor(habit.color)),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            habit.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Row(
                                            children: [
                                              Text(
                                                frequencyText,
                                                style: const TextStyle(
                                                  color: DesignTokens.textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              const Text('·', style: TextStyle(color: DesignTokens.textSecondary)),
                                              const SizedBox(width: 6),
                                              const Icon(Icons.local_fire_department, color: Colors.orange, size: 14),
                                              const SizedBox(width: 4),
                                              Text(
                                                '${habit.currentStreak}',
                                                style: const TextStyle(
                                                  color: DesignTokens.textSecondary,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right,
                                      color: DesignTokens.textTertiary,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              height: 1,
                              thickness: 1,
                              color: Color(0xFF2A2A2A),
                              indent: 60, // Align with text start
                              endIndent: 16,
                            ),
                          ],
                        ),
                      );
                    }),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayHabitItem extends ConsumerWidget {
  final Habit habit;
  final DateTime date;

  const _TodayHabitItem({required this.habit, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(habitProgressProvider((habit, date)));
    final currentProgress = progressAsync.value ?? 0;
    final isCompleted = currentProgress >= habit.targetValue;
    
    final habitColor = _parseColor(habit.color);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitDetailScreen(habit: habit),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            _buildIconWidget(habit.icon, habitColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      color: isCompleted ? DesignTokens.textSecondary : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.local_fire_department, color: habitColor, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        '${habit.currentStreak} days',
                        style: const TextStyle(
                          color: DesignTokens.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Checkmark
            GestureDetector(
              onTap: () {
                ref.read(habitNotifierProvider.notifier).toggleCompletion(habit, date, isCompleted);
              },
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? habitColor : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? habitColor : DesignTokens.borderPrimary,
                    width: 2,
                  ),
                ),
                child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _parseColor(String colorStr) {
  try {
    if (colorStr.startsWith('#')) {
      return Color(int.parse(colorStr.substring(1), radix: 16) + 0xFF000000);
    } else if (colorStr.length == 6) {
      return Color(int.parse(colorStr, radix: 16) + 0xFF000000);
    } else if (colorStr.length == 8) {
      return Color(int.parse(colorStr, radix: 16));
    }
  } catch (_) {}
  return Colors.orange;
}

Widget _buildIconWidget(String iconStr, Color habitColor) {
  return Container(
    width: 32,
    height: 32,
    decoration: BoxDecoration(
      color: habitColor,
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Icon(
        getHabitIcon(iconStr),
        color: Colors.white,
        size: 16,
      ),
    ),
  );
}