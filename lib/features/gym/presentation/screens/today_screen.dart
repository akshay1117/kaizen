import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        title: const Text('Today', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: GymTheme.textPrimary),
            onPressed: () {
              // Export CSV
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCalendarStrip(),
          const SizedBox(height: AppSpacing.lg),
          _buildStreakCard(ref),
          const SizedBox(height: AppSpacing.lg),
          _buildSummaryCard(ref),
          const SizedBox(height: AppSpacing.lg),
          const Text('Session Details', style: TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: AppSpacing.sm),
          _buildSessionDetails(ref),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final now = DateTime.now();
        final date = now.subtract(Duration(days: 3 - index));
        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        final dayStr = days[date.weekday - 1];
        final isToday = index == 3;
        // Mock session data for now, ideally we read from session provider
        final hasSession = index == 1 || index == 3;
        
        return Column(
          children: [
            Text(dayStr, style: const TextStyle(color: GymTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: AppSpacing.sm),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasSession ? GymTheme.primaryAccent : Colors.transparent,
                border: isToday && !hasSession ? Border.all(color: GymTheme.pillUnselected) : null,
              ),
              child: Center(
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: hasSession ? AppColors.textPrimary : (isToday ? GymTheme.textPrimary : GymTheme.textSecondary),
                    fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildStreakCard(WidgetRef ref) {
    final currentStreak = ref.watch(currentStreakProvider);
    final isRest = ref.watch(isRestDayProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Streak', style: TextStyle(color: GymTheme.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  const Icon(Icons.local_fire_department, color: GymTheme.primaryAccent, size: 28),
                  const SizedBox(width: AppSpacing.sm),
                  Text('$currentStreak Days', style: const TextStyle(color: GymTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Rest Days', style: TextStyle(color: GymTheme.textSecondary)),
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.favorite, color: isRest ? GymTheme.primaryAccent : GymTheme.pillUnselected, size: 16),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(WidgetRef ref) {
    final stats = ref.watch(todayStatsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryStat('Sets', stats['sets']!)),
              Expanded(child: _buildSummaryStat('Repetitions', stats['reps']!)),
              Expanded(child: _buildSummaryStat('Exercises', stats['exercises']!)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildSummaryStat('Volume', stats['volume']!)),
              Expanded(child: _buildSummaryStat('Avg Rest', 'N/A')),
              Expanded(child: _buildSummaryStat('Duration', stats['duration']!)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.xs),
        Text(label, style: const TextStyle(color: GymTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildSessionDetails(WidgetRef ref) {
    final setsAsync = ref.watch(allSetEntriesStreamProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: setsAsync.when(
        data: (sets) {
          final now = DateTime.now();
          final todaySets = sets.where((s) => s.performedAt.year == now.year && s.performedAt.month == now.month && s.performedAt.day == now.day).toList();
          if (todaySets.isEmpty) {
            return const Center(child: Text('No sessions today.', style: TextStyle(color: GymTheme.textSecondary)));
          }

          // Simple grouping by exerciseId
          final grouped = <String, List<SetEntry>>{};
          for (var s in todaySets) {
            grouped.putIfAbsent(s.exerciseId, () => []).add(s);
          }

          final tiles = <Widget>[];
          grouped.forEach((exId, exSets) {
            int totalReps = exSets.fold(0, (sum, set) => sum + set.reps);
            double vol = exSets.fold(0.0, (sum, set) => sum + (set.weightKg * set.reps));

            tiles.add(
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Exercise: $exId', style: const TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
                subtitle: Text('${exSets.length} sets · $totalReps reps · ${vol.toStringAsFixed(0)} kg', style: const TextStyle(color: GymTheme.textSecondary)),
                trailing: const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
              )
            );
            tiles.add(const Divider(color: GymTheme.pillUnselected, height: 1));
          });

          if (tiles.isNotEmpty) {
            tiles.removeLast(); // remove last divider
          }

          return Column(children: tiles);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Text('Error: $err'),
      )
    );
  }
}
