import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/services/design_tokens.dart';
import 'package:optimos/view/widget/custom_bottom_nav_bar.dart';
import 'package:optimos/view/widget/habit_heatmap_card.dart';

class HabitsHomeScreen extends ConsumerStatefulWidget {
  const HabitsHomeScreen({super.key});

  @override
  ConsumerState<HabitsHomeScreen> createState() => _HabitsHomeScreenState();
}

class _HabitsHomeScreenState extends ConsumerState<HabitsHomeScreen> {
  final DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int _navIndex = 0;
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'Morning', 'Nutrition', 'Fitness', 'Last 5 days'];

  @override
  Widget build(BuildContext context) {
    final habitsAsync = ref.watch(activeHabitsProvider(_selectedDate));

    return Scaffold(
      backgroundColor: DesignTokens.bgPrimary,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'optimos',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -1,
                            ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: DesignTokens.accentGym.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'PRO',
                              style: TextStyle(
                                color: DesignTokens.accentGym,
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(Icons.bar_chart_rounded, color: DesignTokens.textSecondary),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () => context.pushNamed('add-habit'),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: DesignTokens.bgTertiary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 20),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                // Filters
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = filter == _selectedFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.white : DesignTokens.bgSecondary,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected ? Colors.white : DesignTokens.borderPrimary,
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              filter,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isSelected ? Colors.black : DesignTokens.textSecondary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),

                // Habits List
                Expanded(
                  child: habitsAsync.when(
                    data: (habits) {
                      if (habits.isEmpty) {
                        return Center(
                          child: Text(
                            'No habits found. Tap + to create one.',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120), // Leave space for nav bar
                        itemCount: habits.length,
                        itemBuilder: (context, index) {
                          return HabitHeatmapCard(
                            habit: habits[index],
                            today: _selectedDate,
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(child: Text('Error: $e')),
                  ),
                ),
              ],
            ),
            
            // Floating Bottom Nav Bar
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomBottomNavBar(
                selectedIndex: _navIndex,
                onItemSelected: (index) => setState(() => _navIndex = index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}