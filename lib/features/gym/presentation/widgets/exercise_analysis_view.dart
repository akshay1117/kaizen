import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

enum _AnalysisMode { sets, stats }
enum _SetsTimeRange { last2Sessions, all }
enum _StatsMetric { kgPerRep, sets, reps, volume }
enum _StatsTimeRange { m1, m6, y1 }

class ExerciseAnalysisView extends ConsumerStatefulWidget {
  final String exerciseId;

  const ExerciseAnalysisView({super.key, required this.exerciseId});

  @override
  ConsumerState<ExerciseAnalysisView> createState() => _ExerciseAnalysisViewState();
}

class _ExerciseAnalysisViewState extends ConsumerState<ExerciseAnalysisView> {
  _AnalysisMode _mode = _AnalysisMode.sets;
  _SetsTimeRange _setsTimeRange = _SetsTimeRange.all;
  _StatsMetric _statsMetric = _StatsMetric.volume;
  _StatsTimeRange _statsTimeRange = _StatsTimeRange.m1;

  // Per-metric accent colors matching the SetGraph reference
  static const _metricColors = {
    _StatsMetric.kgPerRep: Color(0xFFFF9F0A), // Orange
    _StatsMetric.sets:     Color(0xFFFF2D55), // Pink/Red
    _StatsMetric.reps:     Color(0xFF30D158), // Green
    _StatsMetric.volume:   Color(0xFF5AC8FA), // Cyan
  };

  Color get _activeColor => _metricColors[_statsMetric] ?? const Color(0xFF5AC8FA);

  @override
  Widget build(BuildContext context) {
    final setsAsync = ref.watch(allSetEntriesStreamProvider);

    return setsAsync.when(
      data: (allSets) {
        final exerciseSets = allSets.where((s) => s.exerciseId == widget.exerciseId).toList();
        
        // Sort by date ascending
        exerciseSets.sort((a, b) => a.performedAt.compareTo(b.performedAt));

        if (exerciseSets.isEmpty) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: GymTheme.textSecondary, fontSize: 14.sp),
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Dynamic Content (Sets Chart or Stats Grid + Chart)
              Expanded(
                child: _mode == _AnalysisMode.sets
                    ? _buildSetsView(exerciseSets)
                    : _buildStatsView(exerciseSets),
              ),
              
              SizedBox(height: 16.h),
              
              // Bottom Toggle (Sets / Stats)
              _buildBottomToggle(),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: GymTheme.destructive))),
    );
  }

  Widget _buildSetsView(List<SetEntry> sets) {
    // Filter sets based on _setsTimeRange
    List<SetEntry> filteredSets = sets;
    if (_setsTimeRange == _SetsTimeRange.last2Sessions) {
      // Find the distinct session dates
      final sessionDates = sets.map((s) => DateTime(s.performedAt.year, s.performedAt.month, s.performedAt.day)).toSet().toList();
      sessionDates.sort();
      if (sessionDates.length > 2) {
        final cutoff = sessionDates[sessionDates.length - 2];
        filteredSets = sets.where((s) => s.performedAt.isAfter(cutoff) || s.performedAt.isAtSameMomentAs(cutoff)).toList();
      }
    }

    final lastSet = sets.last;
    final lastSetDateStr = DateFormat('dd/MM/yy, hh:mm a').format(lastSet.performedAt);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Row(
          children: [
            Text('${lastSet.reps}', style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w800, color: const Color(0xFF34C759), letterSpacing: -1)),
            SizedBox(width: 4.w),
            Text('rep', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color(0xFF34C759))),
            SizedBox(width: 24.w),
            Text('${lastSet.weightKg.toInt()}', style: TextStyle(fontSize: 48.sp, fontWeight: FontWeight.w800, color: const Color(0xFFFF9500), letterSpacing: -1)),
            SizedBox(width: 4.w),
            Text('kg', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600, color: const Color(0xFFFF9500))),
          ],
        ),
        SizedBox(height: 4.h),
        Text('Last Set: $lastSetDateStr', style: TextStyle(fontSize: 14.sp, color: GymTheme.textSecondary)),
        SizedBox(height: 24.h),

        // Line Chart Area
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: GymTheme.cardSurface2,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: GymTheme.cardSurface2),
            ),
            padding: EdgeInsets.all(16.w),
            child: _buildLineChart(filteredSets),
          ),
        ),
        
        SizedBox(height: 24.h),

        // Time Range Controls
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: GymTheme.cardBackground,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildTimeRangeButton(
                  'Last 2 Sessions', 
                  _setsTimeRange == _SetsTimeRange.last2Sessions,
                  () => setState(() => _setsTimeRange = _SetsTimeRange.last2Sessions),
                ),
              ),
              Expanded(
                child: _buildTimeRangeButton(
                  'All', 
                  _setsTimeRange == _SetsTimeRange.all,
                  () => setState(() => _setsTimeRange = _SetsTimeRange.all),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLineChart(List<SetEntry> sets) {
    if (sets.isEmpty) return const SizedBox();

    List<FlSpot> weightSpots = [];
    List<FlSpot> repSpots = [];

    double maxWeight = 0;
    double maxReps = 0;

    for (int i = 0; i < sets.length; i++) {
      final s = sets[i];
      if (s.weightKg > maxWeight) maxWeight = s.weightKg;
      if (s.reps > maxReps) maxReps = s.reps.toDouble();
      
      weightSpots.add(FlSpot(i.toDouble(), s.weightKg));
      repSpots.add(FlSpot(i.toDouble(), s.reps.toDouble()));
    }

    if (maxWeight == 0) maxWeight = 10;
    if (maxReps == 0) maxReps = 10;

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxWeight > 4 ? maxWeight / 4 : 1,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: GymTheme.cardSurface2,
              strokeWidth: 1,
              dashArray: [4, 4],
            );
          },
        ),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          // Reps (Green)
          LineChartBarData(
            spots: repSpots.map((spot) => FlSpot(spot.x, spot.y / maxReps * maxWeight)).toList(), // Normalize reps to weight scale for dual axis illusion
            isCurved: false,
            color: const Color(0xFF34C759),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
          ),
          // Weight (Orange)
          LineChartBarData(
            spots: weightSpots,
            isCurved: false,
            color: const Color(0xFFFF9500),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                radius: 4,
                color: const Color(0xFF1F1F1F),
                strokeWidth: 2,
                strokeColor: const Color(0xFFFF9500),
              ),
            ),
          ),
        ],
        minY: 0,
        maxY: maxWeight * 1.2,
      ),
    );
  }

  Widget _buildStatsView(List<SetEntry> sets) {
    // Filter sets based on _statsTimeRange
    List<SetEntry> filteredSets = sets;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    late DateTime rangeStart;
    
    if (_statsTimeRange == _StatsTimeRange.m1) {
      rangeStart = DateTime(now.year, now.month - 1, now.day);
    } else if (_statsTimeRange == _StatsTimeRange.m6) {
      rangeStart = DateTime(now.year, now.month - 6, now.day);
    } else {
      rangeStart = DateTime(now.year - 1, now.month, now.day);
    }

    filteredSets = sets.where((s) => s.performedAt.isAfter(rangeStart)).toList();

    // Total days in the range (for positioning bars on a real timeline)
    final totalDays = today.difference(rangeStart).inDays;

    // Group by day
    final Map<DateTime, List<SetEntry>> dailySets = {};
    for (var s in filteredSets) {
      final day = DateTime(s.performedAt.year, s.performedAt.month, s.performedAt.day);
      dailySets.putIfAbsent(day, () => []).add(s);
    }

    double totalVolume = 0;
    int totalReps = 0;
    int totalSetsCount = filteredSets.length;
    int totalSessions = dailySets.length;

    for (var s in filteredSets) {
      totalVolume += s.weightKg * (s.reps.toDouble());
      totalReps += s.reps.toInt();
    }

    double avgKgPerRep = totalReps > 0 ? totalVolume / totalReps : 0;
    double avgSetsPerSession = totalSessions > 0 ? totalSetsCount / totalSessions : 0;
    double avgRepsPerSession = totalSessions > 0 ? totalReps / totalSessions : 0;
    double avgVolumePerSession = totalSessions > 0 ? totalVolume / totalSessions : 0;

    // Build bar groups using day-offset as x position
    final sortedDays = dailySets.keys.toList()..sort();
    List<BarChartGroupData> barGroups = [];
    double maxValue = 0;

    // Dynamic bar width and gap based on number of entries
    final int entryCount = sortedDays.length;
    double barWidth;
    double groupsSpace;

    if (entryCount > 60) {
      barWidth = 2.w;
      groupsSpace = 0.5.w;
    } else if (entryCount > 30) {
      barWidth = 4.w;
      groupsSpace = 1.w;
    } else if (entryCount > 15) {
      barWidth = 6.w;
      groupsSpace = 2.w;
    } else if (entryCount > 7) {
      barWidth = 8.w;
      groupsSpace = 4.w;
    } else {
      barWidth = 12.w;
      groupsSpace = 8.w;
    }

    for (final day in sortedDays) {
      final daySets = dailySets[day]!;
      final int dayOffset = day.difference(rangeStart).inDays;

      double dayValue = 0;
      if (_statsMetric == _StatsMetric.kgPerRep) {
        double dVol = 0;
        int dReps = 0;
        for (var s in daySets) { dVol += s.weightKg * (s.reps.toDouble()); dReps += s.reps.toInt(); }
        dayValue = dReps > 0 ? dVol / dReps : 0;
      } else if (_statsMetric == _StatsMetric.sets) {
        dayValue = daySets.length.toDouble();
      } else if (_statsMetric == _StatsMetric.reps) {
        dayValue = daySets.fold<int>(0, (sum, s) => sum + s.reps.toInt()).toDouble();
      } else if (_statsMetric == _StatsMetric.volume) {
        dayValue = daySets.fold<double>(0.0, (sum, s) => sum + (s.weightKg * s.reps.toDouble()));
      }

      if (dayValue > maxValue) maxValue = dayValue;

      barGroups.add(
        BarChartGroupData(
          x: dayOffset,
          barRods: [
            BarChartRodData(
              toY: dayValue,
              color: _activeColor,
              width: barWidth,
              borderRadius: BorderRadius.vertical(top: Radius.circular(2.r)),
            ),
          ],
        ),
      );
    }

    if (maxValue == 0) maxValue = 10;

    // Date range header string
    String dateRangeStr;
    if (_statsTimeRange == _StatsTimeRange.y1) {
      dateRangeStr = "${DateFormat('MMM yyyy').format(rangeStart)} - ${DateFormat('MMM yyyy').format(today)}";
    } else {
      dateRangeStr = "${DateFormat('d MMM').format(rangeStart)} - ${DateFormat('d MMM yyyy').format(today)}";
    }

    // Build bottom axis labels: evenly spaced across the range
    final int labelCount = _statsTimeRange == _StatsTimeRange.m1 ? 5 : 6;
    final double labelInterval = totalDays / labelCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Metrics Grid
        Row(
          children: [
            Expanded(child: _buildMetricBox('kg/rep', avgKgPerRep.toStringAsFixed(1), _StatsMetric.kgPerRep)),
            SizedBox(width: 8.w),
            Expanded(child: _buildMetricBox('Sets', avgSetsPerSession.toStringAsFixed(1), _StatsMetric.sets)),
            SizedBox(width: 8.w),
            Expanded(child: _buildMetricBox('rep', avgRepsPerSession.toStringAsFixed(0), _StatsMetric.reps)),
            SizedBox(width: 8.w),
            Expanded(child: _buildMetricBox('Volume', '${avgVolumePerSession.toStringAsFixed(0)} kg', _StatsMetric.volume)),
          ],
        ),

        SizedBox(height: 16.h),

        // Chart Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _statsTimeRange == _StatsTimeRange.y1 ? 'DAILY AVERAGE' : 'AVERAGE',
              style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, letterSpacing: 1.2, color: GymTheme.textSecondary),
            ),
            Text(dateRangeStr, style: TextStyle(fontSize: 13.sp, color: GymTheme.textSecondary)),
          ],
        ),

        SizedBox(height: 16.h),

        // Bar Chart
        Expanded(
          child: BarChart(
            key: ValueKey('${_statsMetric.name}_${_statsTimeRange.name}'),
            BarChartData(
              alignment: BarChartAlignment.start,
              maxY: maxValue * 1.2,
              minY: 0,
              barTouchData: const BarTouchData(enabled: false),
              titlesData: FlTitlesData(
                show: true,
                // X-axis: Dates
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: labelInterval > 0 ? labelInterval : 1,
                    getTitlesWidget: (value, meta) {
                      final dayIndex = value.toInt();
                      if (dayIndex < 0 || dayIndex > totalDays) return const SizedBox();
                      final date = rangeStart.add(Duration(days: dayIndex));
                      String label;
                      if (_statsTimeRange == _StatsTimeRange.y1) {
                        label = DateFormat('MMM').format(date).substring(0, 1);
                      } else if (_statsTimeRange == _StatsTimeRange.m6) {
                        label = DateFormat('MMM').format(date).substring(0, 1);
                      } else {
                        label = date.day.toString();
                      }
                      return Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Text(
                          label,
                          style: TextStyle(color: GymTheme.textSecondary, fontSize: 11.sp),
                        ),
                      );
                    },
                    reservedSize: 24,
                  ),
                ),
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                // Y-axis: Values
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    interval: maxValue > 4 ? maxValue / 4 : 1,
                    getTitlesWidget: (value, meta) {
                      if (value == 0) return const SizedBox();
                      if (value == meta.max) return const SizedBox();
                      return Padding(
                        padding: EdgeInsets.only(left: 8.w),
                        child: Text(
                          _formatAxisValue(value),
                          style: TextStyle(color: GymTheme.textSecondary, fontSize: 11.sp),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                horizontalInterval: maxValue > 4 ? maxValue / 4 : 1,
                verticalInterval: labelInterval > 0 ? labelInterval : 1,
                getDrawingHorizontalLine: (value) => const FlLine(color: GymTheme.cardSurface2, strokeWidth: 0.5),
                getDrawingVerticalLine: (value) => const FlLine(color: GymTheme.cardSurface2, strokeWidth: 0.5),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  bottom: BorderSide(color: GymTheme.cardSurface2, width: 0.5),
                  left: BorderSide(color: GymTheme.cardSurface2, width: 0.5),
                ),
              ),
              groupsSpace: groupsSpace,
              barGroups: barGroups,
            ),
          ),
        ),
        
        SizedBox(height: 24.h),
        
        // Time Controls
        Container(
          height: 40.h,
          decoration: BoxDecoration(
            color: GymTheme.cardBackground,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Row(
            children: [
              Expanded(child: _buildTimeRangeButton('M', _statsTimeRange == _StatsTimeRange.m1, () => setState(() => _statsTimeRange = _StatsTimeRange.m1), isPill: true)),
              Expanded(child: _buildTimeRangeButton('6M', _statsTimeRange == _StatsTimeRange.m6, () => setState(() => _statsTimeRange = _StatsTimeRange.m6), isPill: true)),
              Expanded(child: _buildTimeRangeButton('Y', _statsTimeRange == _StatsTimeRange.y1, () => setState(() => _statsTimeRange = _StatsTimeRange.y1), isPill: true)),
            ],
          ),
        ),
      ],
    );
  }

  String _formatAxisValue(double value) {
    if (value >= 1000) {
      // Show with commas: 1,000  1,500 etc.
      return NumberFormat('#,##0').format(value.round());
    }
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(1);
  }

  Widget _buildMetricBox(String label, String value, _StatsMetric metric) {
    final isSelected = _statsMetric == metric;
    final accentColor = _metricColors[metric]!;
    // Use dark text on bright backgrounds (green, cyan), white on darker ones (orange, pink)
    final textOnAccent = (metric == _StatsMetric.reps || metric == _StatsMetric.volume)
        ? Colors.black
        : Colors.white;

    return GestureDetector(
      onTap: () => setState(() => _statsMetric = metric),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? accentColor : GymTheme.cardBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: isSelected ? accentColor : GymTheme.cardSurface2),
          boxShadow: isSelected
              ? [BoxShadow(color: accentColor.withValues(alpha: 0.3), blurRadius: 15, spreadRadius: 0)]
              : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: isSelected ? textOnAccent : GymTheme.textSecondary,
                fontSize: 17.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? textOnAccent : GymTheme.textSecondary,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRangeButton(String text, bool isSelected, VoidCallback onTap, {bool isPill = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(isPill ? 4.r : 2.r),
        decoration: BoxDecoration(
          color: isSelected ? GymTheme.cardSurface2 : Colors.transparent,
          borderRadius: BorderRadius.circular(isPill ? 20.r : 6.r),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? GymTheme.textPrimary : GymTheme.textSecondary,
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomToggle() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.all(4.r),
      child: Row(
        children: [
          Expanded(
            child: _buildTimeRangeButton('Sets', _mode == _AnalysisMode.sets, () => setState(() => _mode = _AnalysisMode.sets), isPill: true),
          ),
          Expanded(
            child: _buildTimeRangeButton('Stats', _mode == _AnalysisMode.stats, () => setState(() => _mode = _AnalysisMode.stats), isPill: true),
          ),
        ],
      ),
    );
  }
}
