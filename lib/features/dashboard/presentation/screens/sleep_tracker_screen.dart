import 'package:kaizen/core/theme/app_spacing.dart';
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
                        const SizedBox(height: AppSpacing.md),
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
            const SizedBox(height: AppSpacing.sm * 1.5),
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
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 44),
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
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Sleep Analysis',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 14, color: AppColors.accentLavender),
                            const SizedBox(width: AppSpacing.xs),
                            Text(
                              DateFormat('EEEE, MMM d').format(ref.watch(selectedDateProvider)),
                              style: const TextStyle(
                                fontSize: 15,
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
          const SizedBox(height: AppSpacing.md),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildHeroCard(),
          ),
          const SizedBox(height: AppSpacing.md),
          

          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildWeeklyConsistency(),
          ),
          const SizedBox(height: AppSpacing.md),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildRecentSessions(),
          ),
          const SizedBox(height: AppSpacing.lg),
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
              fontSize: 13,
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
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            hasRecord ? '${hours}h ${minutes}m' : '0h 0m',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        children: [
                          Icon(hasRecord && totalDurationHours >= 7 ? Icons.arrow_upward : Icons.arrow_downward, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: AppSpacing.xs),
                          const Text(
                            '+24m vs 7-day average',
                            style: TextStyle(
                              fontSize: 14,
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
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                    height: 1,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'SCORE',
                                  style: TextStyle(
                                    fontSize: 11,
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
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.accentVelvet.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'OPTIMAL',
                          style: TextStyle(
                            fontSize: 13,
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
              const SizedBox(height: AppSpacing.md),
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
              const SizedBox(width: AppSpacing.xs),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: highlightSubtitleColor ?? (highlightSubtitle ? AppColors.accentLavender : AppColors.textSecondary),
            ),
          ),
        ],
      ),
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
                  fontSize: 20,
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
                  const SizedBox(width: AppSpacing.xs),
                  const Text(
                    'TARGET 8H',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentLavender,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.md),
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
                fontSize: 12,
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
                fontSize: 13,
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
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
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
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
          const SizedBox(height: AppSpacing.md),
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
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: const TextStyle(
                fontSize: 14,
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
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
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
                    fontSize: 13,
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
