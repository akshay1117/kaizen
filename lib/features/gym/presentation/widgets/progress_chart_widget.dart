import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class ProgressChartWidget extends StatefulWidget {
  final List<FlSpot> spots;
  final bool isVolumeChart; // true for bar chart, false for line chart (1RM)

  const ProgressChartWidget({
    super.key,
    required this.spots,
    this.isVolumeChart = false,
  });

  @override
  State<ProgressChartWidget> createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        if (widget.isVolumeChart) {
          return _buildBarChart(context);
        } else {
          return _buildLineChart(context);
        }
      },
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final theme = Theme.of(context);
    final animatedSpots = widget.spots.map((spot) {
      return FlSpot(spot.x, spot.y * _animation.value);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: animatedSpots,
            isCurved: false,
            color: GymTheme.weightAccent,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: GymTheme.weightAccent.withValues(alpha: 0.1 * _animation.value),
            ),
          ),
        ],
        titlesData: const FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
          getDrawingVerticalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        borderData: FlBorderData(show: false),
      ),
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final theme = Theme.of(context);
    
    return BarChart(
      BarChartData(
        barGroups: widget.spots.map((spot) {
          return BarChartGroupData(
            x: spot.x.toInt(),
            barRods: [
              BarChartRodData(
                toY: spot.y * _animation.value,
                color: GymTheme.volumeAccent,
                width: 16,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
        titlesData: const FlTitlesData(
          show: true,
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: theme.dividerColor.withValues(alpha: 0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
      ),
    );
  }
}
