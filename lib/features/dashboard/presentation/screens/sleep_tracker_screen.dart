import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/dashboard/presentation/providers/tracker_providers.dart';
import 'dart:math' as math;
class SleepTrackerScreen extends ConsumerStatefulWidget {
  const SleepTrackerScreen({super.key});

  @override
  ConsumerState<SleepTrackerScreen> createState() => _SleepTrackerScreenState();
}

class _SleepTrackerScreenState extends ConsumerState<SleepTrackerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceObsidian,
      body: Stack(
        children: [
          // Background Gradient Glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, -0.8),
                  radius: 1.5,
                  colors: [
                    AppColors.accentVelvet.withValues(alpha: 0.3),
                    AppColors.surfaceObsidian,
                  ],
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),
          
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildMainCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipRRect(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: AppColors.surfaceElevatedLow.withValues(alpha: 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceElevatedMid,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: AppColors.textPrimary, size: 20),
                  ),
                ),
                const Flexible(
                  child: Text(
                    'Sleep Architecture Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.accentLavender,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: AppColors.surfacePitchBlack, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Drag handle and header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sleep Analysis',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AppColors.accentLavender),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('EEEE, MMM d').format(ref.watch(selectedDateProvider)),
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: AppColors.accentLavender,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceElevatedHigh,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: AppColors.textPrimary, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildDaysSwitcher(),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildHeroCard(),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildArchitecture(),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildWeeklyConsistency(),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildRecentSessions(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDaysSwitcher() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfacePitchBlack,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(7, (index) {
          final date = today.subtract(Duration(days: 6 - index));
          final isSelected = date.year == selectedDate.year &&
              date.month == selectedDate.month &&
              date.day == selectedDate.day;
          return _buildDayPill(DateFormat('E').format(date), isSelected, date);
        }),
      ),
    );
  }

  Widget _buildDayPill(String day, bool isSelected, DateTime date) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedDateProvider.notifier).state = date;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentLavender : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.accentLavender.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              color: isSelected ? AppColors.surfacePitchBlack : AppColors.textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    final sleepRecords = ref.watch(sleepRecordsProvider).value ?? [];
    final hasRecord = sleepRecords.isNotEmpty;
    final totalDurationHours = ref.watch(sleepDurationProvider);
    final int hours = totalDurationHours.floor();
    final int minutes = ((totalDurationHours - hours) * 60).round();
    
    final int score = hasRecord ? (sleepRecords.first.sleepScore ?? 85) : 0;
    
    String bedtimeStr = '--:--';
    String wakeupStr = '--:--';
    
    if (hasRecord) {
      final record = sleepRecords.first;
      bedtimeStr = DateFormat('h:mm a').format(record.bedtime);
      wakeupStr = DateFormat('h:mm a').format(record.wakeupTime);
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedMid,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -48,
            right: -48,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentVelvet.withValues(alpha: 0.2),
              ),
              child: BackdropFilter(
                filter: ColorFilter.mode(Colors.black.withValues(alpha: 0.01), BlendMode.dstOut),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentVelvet.withValues(alpha: 0.3),
                        blurRadius: 48,
                        spreadRadius: 24,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TIME ASLEEP',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            hasRecord ? '${hours}h ${minutes}m' : '0h 0m',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(hasRecord && totalDurationHours >= 7 ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          const Text(
                            '+24m vs 7-day average',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform.rotate(
                              angle: -math.pi / 2,
                              child: const CircularProgressIndicator(
                                value: 1.0,
                                strokeWidth: 6,
                                color: AppColors.surfaceElevatedHigh,
                              ),
                            ),
                            Transform.rotate(
                              angle: -math.pi / 2,
                              child: CircularProgressIndicator(
                                value: hasRecord ? score / 100 : 0.0,
                                strokeWidth: 6,
                                color: AppColors.accentVelvet,
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  hasRecord ? score.toString() : '-',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'SCORE',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textSecondary,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentVelvet.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'OPTIMAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentLavender,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 1.6,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                children: [
                  _buildMetricCard(Icons.bedtime, 'BEDTIME', bedtimeStr, 'Within 10m window'),
                  _buildMetricCard(Icons.wb_sunny, 'WAKE-UP', wakeupStr, 'Natural arousal'),
                  _buildMetricCard(Icons.track_changes, 'SLEEP GOAL', '8h 00m', hasRecord ? '${(totalDurationHours > 8 ? '+' : '')}${((totalDurationHours - 8) * 60).round()}m vs target' : 'No data', highlightSubtitle: totalDurationHours >= 8),
                  _buildMetricCard(Icons.psychology, 'DEEP & REM', hasRecord ? '${(hours * 0.4).round()}h ${(minutes * 0.4).round()}m' : '--:--', '50% restorative', highlightSubtitleColor: Colors.lightBlue),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String title, String value, String subtitle, {bool highlightSubtitle = false, Color? highlightSubtitleColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: highlightSubtitleColor ?? (highlightSubtitle ? AppColors.accentLavender : AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArchitecture() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedMid,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.graphic_eq, color: AppColors.accentLavender, size: 20),
                  SizedBox(width: 6),
                  Text(
                    'Architecture',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                'HYPNOGRAM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('11:15 PM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              Text('03:00 AM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
              Text('07:35 AM', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 96,
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfacePitchBlack,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned(top: 12, left: 0, right: 0, child: CustomPaint(painter: _DashedLinePainter(color: AppColors.surfaceElevatedHigh))),
                Positioned(top: 32, left: 0, right: 0, child: CustomPaint(painter: _DashedLinePainter(color: AppColors.surfaceElevatedHigh))),
                Positioned(top: 52, left: 0, right: 0, child: CustomPaint(painter: _DashedLinePainter(color: AppColors.surfaceElevatedHigh))),
                Positioned(top: 72, left: 0, right: 0, child: CustomPaint(painter: _DashedLinePainter(color: AppColors.surfaceElevatedHigh))),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HypnogramPainter(color: AppColors.accentVelvet),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 12,
              child: Row(
                children: [
                  Expanded(flex: 5, child: Container(color: AppColors.textSecondary)),
                  Expanded(flex: 24, child: Container(color: AppColors.accentLavender.withValues(alpha: 0.5))),
                  Expanded(flex: 51, child: Container(color: AppColors.accentLavender)),
                  Expanded(flex: 20, child: Container(color: AppColors.accentVelvet)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 3.5,
            mainAxisSpacing: 8,
            crossAxisSpacing: 16,
            children: [
              _buildLegendItem(AppColors.textSecondary, 'Awake', '5% • 25m'),
              _buildLegendItem(AppColors.accentLavender.withValues(alpha: 0.5), 'REM', '24% • 2h 00m'),
              _buildLegendItem(AppColors.accentLavender, 'Light Sleep', '51% • 4h 15m'),
              _buildLegendItem(AppColors.accentVelvet, 'Deep Sleep', '20% • 1h 40m'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyConsistency() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedMid,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Weekly Consistency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accentLavender,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'TARGET 8H',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentLavender,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 144,
            child: Stack(
              children: [
                Positioned(
                  top: 30,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    painter: _DashedLinePainter(color: AppColors.accentLavender.withValues(alpha: 0.4)),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(0.68, '7.2h', 'M'),
                    _buildBar(0.78, '8.1h', 'T'),
                    _buildBar(0.75, '7.9h', 'W'),
                    _buildBar(0.82, '8.3h', 'T'),
                    _buildBar(0.82, '8.3h', 'F', isHighlighted: true),
                    _buildBar(0.10, '—', 'S', isDimmed: true),
                    _buildBar(0.10, '—', 'S', isDimmed: true),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.surfaceElevatedHigh.withValues(alpha: 0.5)),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat('WEEKLY AVG', '7h 48m', AppColors.textPrimary),
                _buildStat('PEAK RECORD', 'Fri (8h 20m)', AppColors.accentLavender),
                _buildStat('STABILITY', '94% Score', Colors.lightBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double heightFactor, String topLabel, String bottomLabel, {bool isHighlighted = false, bool isDimmed = false}) {
    return Expanded(
      child: Opacity(
        opacity: isDimmed ? 0.4 : 1.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              topLabel,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? AppColors.accentLavender : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: constraints.maxWidth * 0.7,
                      height: constraints.maxHeight * heightFactor,
                      decoration: BoxDecoration(
                        color: isHighlighted ? AppColors.accentVelvet : AppColors.surfaceElevatedHigh,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        boxShadow: isHighlighted ? [
                          BoxShadow(
                            color: AppColors.accentVelvet.withValues(alpha: 0.3),
                            blurRadius: 4,
                          )
                        ] : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(
              bottomLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? AppColors.accentLavender : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String title, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSessions() {
    final weeklyRecords = ref.watch(weeklySleepRecordsProvider).value ?? [];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedMid,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Sessions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (weeklyRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text('No recent sessions found', style: TextStyle(color: AppColors.textSecondary)),
            )
          else
            ...weeklyRecords.map((record) {
              final duration = record.wakeupTime.difference(record.bedtime);
              final hours = duration.inHours;
              final minutes = duration.inMinutes.remainder(60);
              final score = record.sleepScore ?? 0;
              final status = score >= 85 ? 'Optimal' : (score >= 70 ? 'Fair' : 'Poor');
              
              return Column(
                children: [
                  _buildSessionRow(
                    DateFormat('E, MMM d').format(record.date),
                    '${DateFormat('h:mm a').format(record.bedtime)} – ${DateFormat('h:mm a').format(record.wakeupTime)}',
                    '${hours}h ${minutes}m',
                    status,
                    score.toString(),
                    scoreDimmed: score < 85,
                  ),
                  if (record != weeklyRecords.last)
                    Divider(color: AppColors.surfaceElevatedHigh.withValues(alpha: 0.5), height: 24),
                ],
              );
            }),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              final selectedDate = ref.read(selectedDateProvider);
              final bedtime = DateTime(selectedDate.year, selectedDate.month, selectedDate.day - 1, 23, 0);
              final wakeup = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 7, 0);
              final score = 80 + (DateTime.now().millisecond % 15);
              ref.read(healthRepositoryProvider).addSleepRecord(bedtime, wakeup, score, selectedDate);
            },
            icon: const Icon(Icons.add_circle, size: 18),
            label: const Text(
              'Add / Adjust Sleep Record',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.surfaceElevatedHigh,
              foregroundColor: AppColors.accentLavender,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionRow(String date, String time, String duration, String status, String score, {bool scoreDimmed = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  duration,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: AppColors.surfaceElevatedHigh,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  score,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: scoreDimmed ? AppColors.textSecondary : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Color color;
  _DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    const double dashWidth = 2.0;
    const double dashSpace = 2.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HypnogramPainter extends CustomPainter {
  final Color color;
  _HypnogramPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;
      
    final Path path = Path();
    // Recreating path from HTML:
    // d="M0,12 L14,12 L14,52 L40,52 L40,72 L85,72 L85,52 L110,52 L110,32 L150,32 L150,52 L180,52 L180,72 L220,72 L220,32 L260,32 L260,52 L290,52 L290,12 L300,12 L300,32 L320,32"
    // ViewBox was 320x80. We need to scale to `size.width` and `size.height`
    double wRatio = size.width / 320;
    double hRatio = size.height / 80;
    
    path.moveTo(0 * wRatio, 12 * hRatio);
    path.lineTo(14 * wRatio, 12 * hRatio);
    path.lineTo(14 * wRatio, 52 * hRatio);
    path.lineTo(40 * wRatio, 52 * hRatio);
    path.lineTo(40 * wRatio, 72 * hRatio);
    path.lineTo(85 * wRatio, 72 * hRatio);
    path.lineTo(85 * wRatio, 52 * hRatio);
    path.lineTo(110 * wRatio, 52 * hRatio);
    path.lineTo(110 * wRatio, 32 * hRatio);
    path.lineTo(150 * wRatio, 32 * hRatio);
    path.lineTo(150 * wRatio, 52 * hRatio);
    path.lineTo(180 * wRatio, 52 * hRatio);
    path.lineTo(180 * wRatio, 72 * hRatio);
    path.lineTo(220 * wRatio, 72 * hRatio);
    path.lineTo(220 * wRatio, 32 * hRatio);
    path.lineTo(260 * wRatio, 32 * hRatio);
    path.lineTo(260 * wRatio, 52 * hRatio);
    path.lineTo(290 * wRatio, 52 * hRatio);
    path.lineTo(290 * wRatio, 12 * hRatio);
    path.lineTo(300 * wRatio, 12 * hRatio);
    path.lineTo(300 * wRatio, 32 * hRatio);
    path.lineTo(320 * wRatio, 32 * hRatio);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
