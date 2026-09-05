import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'dart:math' as math;

class DonutChartWidget extends ConsumerWidget {
  const DonutChartWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final selectedPeriod = ref.watch(selectedTimePeriodProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return transactionsAsync.when(
      data: (transactions) {
        double totalExpense = 0;
        final categoryTotals = <String, double>{};
        final categoryColors = <String, Color>{};

        for (final t in transactions) {
          if (!t.transaction.isIncome) {
            totalExpense += t.transaction.amount;
            final catName = t.category.name;
            categoryTotals[catName] = (categoryTotals[catName] ?? 0) + t.transaction.amount;
            
            String hex = t.category.colorHex;
            if (hex.length == 6) hex = 'FF$hex';
            categoryColors[catName] = Color(int.parse(hex, radix: 16));
          }
        }

        final percentages = <double>[];
        final colors = <Color>[];
        if (totalExpense > 0) {
          categoryTotals.forEach((catName, total) {
            percentages.add((total / totalExpense) * 100);
            colors.add(categoryColors[catName] ?? Colors.grey);
          });
        }

        // Calculate averages based on period
        int days = 1;
        if (selectedPeriod == '7D') { days = 7; }
        else if (selectedPeriod == '1M') { days = 30; }
        else if (selectedPeriod == '3M') { days = 90; }
        else if (selectedPeriod == '1Y') { days = 365; }

        final dailyAvg = totalExpense / days;

        String periodTitle = 'Custom Range';
        if (selectedPeriod == '24H') { periodTitle = 'Last 24 hours'; }
        else if (selectedPeriod == '7D') { periodTitle = 'Last 7 days'; }
        else if (selectedPeriod == '1M') { periodTitle = 'Last 30 days'; }
        else if (selectedPeriod == '3M') { periodTitle = 'Last 90 days'; }
        else if (selectedPeriod == '1Y') { periodTitle = 'Last 365 days'; }

        return Center(
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF151517),
              border: Border.all(color: AppColors.borderSpecular, width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: DonutPainter(percentages, colors, 16),
                  ),
                ),
                // Inner content
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      periodTitle,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Total:',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                    Text(
                      formatter.format(totalExpense),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          children: [
                            const Text('ø per day:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(formatter.format(dailyAvg), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          children: [
                            const Text('ø per person:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            const SizedBox(height: 2),
                            Text(formatter.format(totalExpense), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox(height: 320, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: 320),
    );
  }
}

class DonutPainter extends CustomPainter {
  final List<double> percentages;
  final List<Color> colors;
  final double strokeWidth;

  DonutPainter(this.percentages, this.colors, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - strokeWidth / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Draw background track
    final bgPaint = Paint()
      ..color = AppColors.surfaceElevatedHigh
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    if (percentages.isEmpty) return;

    // Draw segments
    double startAngle = -math.pi / 2; // -90 degrees
    const gapAngle = 0.08; // gap in radians

    for (int i = 0; i < percentages.length; i++) {
      final sweepAngle = (percentages[i] / 100) * 2 * math.pi;
      
      final segmentPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      if (sweepAngle > gapAngle * 2) {
        canvas.drawArc(rect, startAngle + gapAngle, sweepAngle - gapAngle * 2, false, segmentPaint);
      } else if (sweepAngle > 0) {
        canvas.drawArc(rect, startAngle + sweepAngle / 2, 0.001, false, segmentPaint);
      }
      
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(DonutPainter oldDelegate) => true;
}
