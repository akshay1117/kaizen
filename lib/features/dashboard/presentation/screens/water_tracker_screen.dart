import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:kaizen/features/dashboard/presentation/providers/tracker_providers.dart';

class WaterTrackerScreen extends ConsumerStatefulWidget {
  const WaterTrackerScreen({super.key});

  @override
  ConsumerState<WaterTrackerScreen> createState() => _WaterTrackerScreenState();
}

class _WaterTrackerScreenState extends ConsumerState<WaterTrackerScreen> {
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
                        _buildHeader(),
                        const SizedBox(height: AppSpacing.md),
                        _buildDaysSwitcher(),
                        const SizedBox(height: AppSpacing.md),
                        _buildHeroCard(),
                        const SizedBox(height: AppSpacing.md),
                        _buildIntakeDistribution(),
                        const SizedBox(height: AppSpacing.md),
                        _buildQuickActions(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildTodaysLogs(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildPreviousDays(),
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
                const Text(
                  'Water Intake Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
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

  Widget _buildHeader() {
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = selectedDate.year == DateTime.now().year && selectedDate.month == DateTime.now().month && selectedDate.day == DateTime.now().day;
    final dateStr = isToday ? 'Today, ${DateFormat('MMM d').format(selectedDate)}' : DateFormat('EEE, MMM d').format(selectedDate);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.accentLavender.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.water_drop, color: AppColors.accentLavender, size: 18),
            ),
            const SizedBox(width: AppSpacing.sm),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Water Intake',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.2,
                  ),
                ),
                Text(
                  'Daily hydration telemetry',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedMid,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 2,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: AppColors.accentLavender),
              const SizedBox(width: AppSpacing.xs),
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.expand_more, size: 14, color: AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDaysSwitcher() {
    final now = DateTime.now();
    final selectedDate = ref.watch(selectedDateProvider);
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfacePitchBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final dayDate = now.subtract(Duration(days: 4 - index));
          final isSelected = selectedDate.year == dayDate.year && selectedDate.month == dayDate.month && selectedDate.day == dayDate.day;
          
          String dayLabel;
          if (index == 4) {
            dayLabel = 'TODAY';
          } else {
            dayLabel = DateFormat('E').format(dayDate).toUpperCase();
          }
          
          return _buildDayItem(dayLabel, dayDate.day.toString(), isSelected, dayDate);
        }),
      ),
    );
  }

  Widget _buildDayItem(String day, String date, bool isSelected, DateTime fullDate) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedDateProvider.notifier).state = DateTime(fullDate.year, fullDate.month, fullDate.day);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentVelvet : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected
                ? LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.accentLavender.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  )
                : null,
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Column(
            children: [
              Text(
                day,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.accentLavender : AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    final intake = ref.watch(waterIntakeProvider) / 1000.0; // from ml to Liters
    const target = 4.0;
    final remaining = (target - intake) > 0 ? (target - intake) : 0.0;
    final percent = (intake / target).clamp(0.0, 1.0);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -64,
            right: -64,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.accentLavender.withValues(alpha: 0.1),
              ),
              child: BackdropFilter(
                filter: ColorFilter.mode(Colors.black.withValues(alpha: 0.01), BlendMode.dstOut),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentLavender.withValues(alpha: 0.15),
                        blurRadius: 48,
                        spreadRadius: 24,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'CURRENT STATUS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.accentLavender.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.accentLavender,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text(
                            '${(percent * 100).toInt()}% Completed',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentLavender,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      intake.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Text(
                      'L',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.accentLavender,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      percent >= 1.0 ? 'Optimum target achieved' : 'Keep hydrating',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm * 1.5),
                Row(
                  children: List.generate(4, (index) {
                    final blockPercent = (percent * 4) - index;
                    final fill = blockPercent.clamp(0.0, 1.0);
                    return Expanded(
                      child: Container(
                        height: 10,
                        margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevatedHigh,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FractionallySizedBox(
                            widthFactor: fill,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.accentLavender,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: fill > 0 ? [
                                  BoxShadow(
                                    color: AppColors.accentLavender.withValues(alpha: 0.4),
                                    blurRadius: 4,
                                  ),
                                ] : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 6),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('0.0 L', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('1.0 L', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('2.0 L', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('3.0 L', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                    Text('4.0 L', style: TextStyle(fontSize: 11, color: AppColors.accentLavender, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(Icons.flag, 'DAILY GOAL', '${target.toStringAsFixed(1)} Liters', AppColors.textTertiary),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildMetricCard(Icons.check_circle, 'REMAINING', '${remaining.toStringAsFixed(1)} Liters', AppColors.accentLavender),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(IconData icon, String title, String value, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedMid,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.surfaceElevatedHigh,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeDistribution() {
    final hourlyBins = ref.watch(waterHourlyIntakeProvider);
    final maxBin = hourlyBins.values.fold(0.0, (m, v) => v > m ? v : m);
    final isSelectedDateToday = ref.watch(selectedDateProvider).day == DateTime.now().day;
    final currentHour = DateTime.now().hour;
    
    // Find active bin based on hour if it's today
    String activeBin = '';
    if (isSelectedDateToday) {
      if (currentHour >= 6 && currentHour < 9) {
        activeBin = '6-8a';
      } else if (currentHour >= 9 && currentHour < 11) {
        activeBin = '9-11a';
      } else if (currentHour >= 11 && currentHour < 14) {
        activeBin = '11-2p';
      } else if (currentHour >= 14 && currentHour < 16) {
        activeBin = '2-4p';
      } else if (currentHour >= 16) {
        activeBin = '4p-Now';
      }
    }

    String topBin = '11-2p';
    double topBinVal = 0.0;
    hourlyBins.forEach((key, value) {
      if (value > topBinVal) {
        topBinVal = value;
        topBin = key;
      }
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Intake Distribution',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Time-bracketed consumption breakdown',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
                    'Hourly Pacing',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Tooltip
          if (topBinVal > 0) Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.accentVelvet,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.bolt, color: AppColors.accentLavender, size: 18),
                    const SizedBox(width: AppSpacing.sm),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(text: '$topBin: '),
                          TextSpan(text: '${topBinVal.toInt()} ml', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePitchBlack,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HYDRATION BOOST',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.accentLavender,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Histogram Chart
          SizedBox(
            height: 180,
            child: Stack(
              children: [
                Positioned(
                  top: 48,
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          painter: _DashedLinePainter(color: AppColors.textTertiary.withValues(alpha: 0.6)),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        '${maxBin > 0 ? (maxBin * 0.75).toInt() : 800}ml Avg',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildIntakeBar('${hourlyBins['6-8a']!.toInt()}', '6-8a', maxBin == 0 ? 0 : hourlyBins['6-8a']! / (maxBin * 1.2), activeBin == '6-8a'),
                    _buildIntakeBar('${hourlyBins['9-11a']!.toInt()}', '9-11a', maxBin == 0 ? 0 : hourlyBins['9-11a']! / (maxBin * 1.2), activeBin == '9-11a'),
                    _buildIntakeBar('${hourlyBins['11-2p']!.toInt()}', '11-2p', maxBin == 0 ? 0 : hourlyBins['11-2p']! / (maxBin * 1.2), activeBin == '11-2p'),
                    _buildIntakeBar('${hourlyBins['2-4p']!.toInt()}', '2-4p', maxBin == 0 ? 0 : hourlyBins['2-4p']! / (maxBin * 1.2), activeBin == '2-4p'),
                    _buildIntakeBar('${hourlyBins['4p-Now']!.toInt()}', '4p-Now', maxBin == 0 ? 0 : hourlyBins['4p-Now']! / (maxBin * 1.2), activeBin == '4p-Now'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntakeBar(String value, String label, double heightRatio, bool isActive) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: isActive ? AppColors.accentLavender : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: 36,
                  height: constraints.maxHeight * heightRatio,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevatedMid,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppColors.accentLavender.withValues(alpha: 0.4),
                              blurRadius: 4,
                            )
                          ]
                        : null,
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: 36,
                      height: constraints.maxHeight * heightRatio, // Using full height for the fill as per HTML design, the background handles empty part if any. Oh wait, the HTML has fill height 100% inside a container of ratio height.
                      decoration: BoxDecoration(
                        color: isActive ? null : AppColors.accentLavender.withValues(alpha: 0.7),
                        gradient: isActive
                            ? const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [AppColors.accentLavender, AppColors.accentViolet],
                              )
                            : null,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              color: isActive ? AppColors.accentLavender : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final selectedDate = ref.watch(selectedDateProvider);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'QUICK INTAKE INCREMENT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  letterSpacing: 1.2,
                ),
              ),
              Icon(Icons.speed, size: 16, color: AppColors.textSecondary),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: _buildIncrementButton('+250 ml', '1 Glass', 250, selectedDate)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildIncrementButton('+500 ml', 'Standard Flask', 500, selectedDate)),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: _buildIncrementButton('+750 ml', 'Active Bottle', 750, selectedDate)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () {
              // We could show a dialog to enter custom amount
            },
            icon: const Icon(Icons.add, size: 18),
            label: const Text(
              'Log Custom Water Amount',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentLavender,
              foregroundColor: AppColors.surfacePitchBlack,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              shadowColor: AppColors.accentLavender.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIncrementButton(String amountLabel, String label, double amountValue, DateTime date) {
    return InkWell(
      onTap: () {
        ref.read(healthRepositoryProvider).addWater(amountValue, date);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevatedMid,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              amountLabel,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.accentLavender,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysLogs() {
    final entriesAsync = ref.watch(waterEntriesProvider);
    
    return entriesAsync.when(
      data: (entries) {
        if (entries.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Today's Logs",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${entries.length} ENTRIES',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: _buildLogItem(
                  Icons.local_drink,
                  '${entry.amount.toInt()} ml',
                  'Water',
                  DateFormat('h:mm a').format(entry.createdAt),
                  AppColors.accentLavender,
                  entry.id,
                ),
              );
            }),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildLogItem(IconData icon, String amount, String type, String time, Color iconColor, String id) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevatedMid,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.sm * 1.5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        amount,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevatedHigh,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          type,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
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
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 16, color: AppColors.textSecondary),
                onPressed: () {},
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
              ),
              IconButton(
                icon: const Icon(Icons.delete, size: 16, color: AppColors.textSecondary),
                onPressed: () {
                  ref.read(healthRepositoryProvider).deleteWaterEntry(id);
                },
                visualDensity: VisualDensity.compact,
                splashRadius: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousDays() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Previous Days',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Trends',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentLavender,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevatedLow,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildPreviousDayItem('Yesterday', '3.8 L consumed', 0.95, AppColors.accentLavender.withValues(alpha: 0.6)),
              const SizedBox(height: AppSpacing.sm * 1.5),
              _buildPreviousDayItem('Wed, Oct 22', '4.2 L consumed', 1.0, AppColors.accentLavender, isOver: true),
              const SizedBox(height: AppSpacing.sm * 1.5),
              _buildPreviousDayItem('Tue, Oct 21', '3.5 L consumed', 0.87, AppColors.textSecondary),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPreviousDayItem(String day, String subtitle, double percent, Color color, {bool isOver = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  day,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 80,
              height: 6,
              decoration: BoxDecoration(
                color: AppColors.surfaceElevatedHigh,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: percent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            SizedBox(
              width: 36,
              child: Text(
                '${(percent * 100).toInt()}%',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isOver ? FontWeight.bold : FontWeight.w500,
                  color: isOver ? AppColors.accentLavender : AppColors.textSecondary,
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
    const double dashWidth = 4.0;
    const double dashSpace = 4.0;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
