import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

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
          const SizedBox(height: 24),
          _buildStreakCard(),
          const SizedBox(height: 24),
          _buildSummaryCard(),
          const SizedBox(height: 24),
          const Text('Session Details', style: TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          _buildSessionDetails(),
        ],
      ),
    );
  }

  Widget _buildCalendarStrip() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
        final isToday = index == 3; // Mock today
        final hasSession = index == 1 || index == 3;
        
        return Column(
          children: [
            Text(days[index], style: const TextStyle(color: GymTheme.textSecondary, fontSize: 12)),
            const SizedBox(height: 8),
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
                  '${15 + index}',
                  style: TextStyle(
                    color: hasSession ? Colors.white : (isToday ? GymTheme.textPrimary : GymTheme.textSecondary),
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

  Widget _buildStreakCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Streak', style: TextStyle(color: GymTheme.textSecondary)),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.local_fire_department, color: GymTheme.primaryAccent, size: 28),
                  SizedBox(width: 8),
                  Text('12 Days', style: TextStyle(color: GymTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('Rest Days', style: TextStyle(color: GymTheme.textSecondary)),
              const SizedBox(height: 4),
              Row(
                children: List.generate(3, (index) => const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.favorite, color: GymTheme.primaryAccent, size: 16),
                )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSummaryStat('Sets', '15')),
              Expanded(child: _buildSummaryStat('Repetitions', '150')),
              Expanded(child: _buildSummaryStat('Exercises', '4')),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildSummaryStat('Volume', '4500 kg')),
              Expanded(child: _buildSummaryStat('Avg Rest', '1m 30s')),
              Expanded(child: _buildSummaryStat('Duration', '45m')),
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
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: GymTheme.textSecondary, fontSize: 12)),
      ],
    );
  }

  Widget _buildSessionDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Bench Press', style: TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
            subtitle: Text('4 sets · 32 reps · 1200 kg', style: TextStyle(color: GymTheme.textSecondary)),
            trailing: Icon(Icons.chevron_right, color: GymTheme.textSecondary),
          ),
          Divider(color: GymTheme.pillUnselected, height: 1),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Squat', style: TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
            subtitle: Text('3 sets · 30 reps · 1500 kg', style: TextStyle(color: GymTheme.textSecondary)),
            trailing: Icon(Icons.chevron_right, color: GymTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
