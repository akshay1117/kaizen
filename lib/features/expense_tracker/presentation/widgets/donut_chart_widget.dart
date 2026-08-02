import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';

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

        final sections = <PieChartSectionData>[];
        if (totalExpense > 0) {
          categoryTotals.forEach((catName, total) {
            final percentage = (total / totalExpense) * 100;
            sections.add(
              PieChartSectionData(
                color: categoryColors[catName] ?? Colors.grey,
                value: percentage,
                title: '',
                radius: 12,
              ),
            );
          });
        } else {
          // Empty state donut
          sections.add(
            PieChartSectionData(
              color: const Color(0xFF1C1C1E),
              value: 100,
              title: '',
              radius: 12,
            ),
          );
        }

        // Calculate averages based on period
        int days = 1;
        if (selectedPeriod == '7D') {
          days = 7;
        } else if (selectedPeriod == '1M') {
          days = 30;
        } else if (selectedPeriod == '3M') {
          days = 90;
        } else if (selectedPeriod == '1Y') {
          days = 365;
        }

        final dailyAvg = totalExpense / days;

        // Determine title text based on period
        String periodTitle = 'Custom Range';
        if (selectedPeriod == '24H') {
          periodTitle = 'Last 24 hours';
        } else if (selectedPeriod == '7D') {
          periodTitle = 'Last 7 days';
        } else if (selectedPeriod == '1M') {
          periodTitle = 'Last 30 days';
        } else if (selectedPeriod == '3M') {
          periodTitle = 'Last 90 days';
        } else if (selectedPeriod == '1Y') {
          periodTitle = 'Last 365 days';
        }

        return SizedBox(
          height: 250,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 90,
                  startDegreeOffset: -90,
                  sections: sections,
                ),
              ),
              // Inner content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    periodTitle,
                    style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Total:',
                    style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                  ),
                  Text(
                    formatter.format(totalExpense),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Ø per day: ${formatter.format(dailyAvg)}',
                        style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 10),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ø per person: ${formatter.format(totalExpense)}', // Hardcoded 1 person for now
                        style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(height: 250, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: 250),
    );
  }
}
