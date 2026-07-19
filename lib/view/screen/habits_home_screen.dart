import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:optimos/controller/habit_providers.dart';
import 'package:optimos/model/database.dart';
import 'package:optimos/services/design_tokens.dart';
import 'package:optimos/view/widget/custom_bottom_nav_bar.dart';
import 'package:optimos/view/widget/habit_heatmap_card.dart';
import 'package:optimos/view/widget/habit_weekly_card.dart';
import 'package:optimos/view/widget/habit_monthly_card.dart';

class HabitsHomeScreen extends ConsumerStatefulWidget {
  const HabitsHomeScreen({super.key});

  @override
  ConsumerState<HabitsHomeScreen> createState() => _HabitsHomeScreenState();
}

class _HabitsHomeScreenState extends ConsumerState<HabitsHomeScreen> {
  final DateTime _selectedDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  int _navIndex = 0;
  String _selectedFilter = 'All';

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
                // Habits List
                Expanded(
                  child: habitsAsync.when(
                    data: (allHabits) {
                      // Extract categories dynamically
                      final Set<String> activeCategories = {};
                      for (var habit in allHabits) {
                        if (habit.categories != null && habit.categories!.isNotEmpty) {
                          activeCategories.addAll(habit.categories!.split(',').map((e) => e.trim()));
                        }
                      }
                      
                      final List<String> dynamicFilters = ['All', ...activeCategories.toList()..sort()];
                      
                      // Filter habits based on selection
                      final List<Habit> filteredHabits = _selectedFilter == 'All' || !dynamicFilters.contains(_selectedFilter)
                          ? allHabits
                          : allHabits.where((h) => h.categories != null && h.categories!.split(',').map((e) => e.trim()).contains(_selectedFilter)).toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filters
                          if (dynamicFilters.length > 1) // Only show if there's more than just 'All'
                            SizedBox(
                              height: 40,
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                scrollDirection: Axis.horizontal,
                                itemCount: dynamicFilters.length,
                                separatorBuilder: (context, index) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final filter = dynamicFilters[index];
                                  // Fallback to 'All' if selected filter no longer exists
                                  final isSelected = filter == _selectedFilter || (_selectedFilter != 'All' && !dynamicFilters.contains(_selectedFilter) && filter == 'All');
                                  
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
                          if (_navIndex == 1 && dynamicFilters.length > 1) // Add some spacing before header
                            const SizedBox(height: 8),
                            
                          if (_navIndex == 1) // Date header for weekly view
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 8.0, top: 16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: DesignTokens.bgSecondary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: DesignTokens.borderPrimary,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'Last 5 days',
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: DesignTokens.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    children: List.generate(5, (index) {
                                      final date = _selectedDate.subtract(Duration(days: 4 - index));
                                      return Container(
                                        width: 32,
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              DateFormat('E').format(date).substring(0, 2),
                                              style: const TextStyle(color: DesignTokens.textTertiary, fontSize: 12),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${date.day}',
                                              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          
                          Expanded(
                            child: filteredHabits.isEmpty
                                ? Center(
                                    child: Text(
                                      allHabits.isEmpty ? 'No habits found. Tap + to create one.' : 'No habits in this category.',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  )
                                : _navIndex == 2
                                    ? GridView.builder(
                                        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 120),
                                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          childAspectRatio: 0.8,
                                        ),
                                        itemCount: filteredHabits.length,
                                        itemBuilder: (context, index) {
                                          return ConnectedHabitMonthlyCard(
                                            habit: filteredHabits[index],
                                            today: _selectedDate,
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        padding: const EdgeInsets.only(bottom: 120), // Leave space for nav bar
                                        itemCount: filteredHabits.length,
                                        itemBuilder: (context, index) {
                                          if (_navIndex == 1) {
                                            return ConnectedHabitWeeklyCard(
                                              habit: filteredHabits[index],
                                              today: _selectedDate,
                                            );
                                          }
                                          return ConnectedHabitHeatmapCard(
                                            habit: filteredHabits[index],
                                            today: _selectedDate,
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