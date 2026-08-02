import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_dao.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timePeriod = ref.watch(analyticsTimePeriodProvider);
    final transactionsAsync = ref.watch(analyticsTransactionsProvider);
    final currentTrackerAsync = ref.watch(currentTrackerProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Matching the pitch black in video
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analytics',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: transactionsAsync.when(
        data: (transactions) => _buildBody(context, ref, transactions, currentTrackerAsync.value, timePeriod, formatter),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, 
    WidgetRef ref, 
    List<TransactionWithDetails> transactions, 
    ExpenseTracker? currentTracker,
    String timePeriod,
    NumberFormat formatter,
  ) {
    // 1. Calculate totals
    double totalSpent = 0;
    Map<String, double> categoryTotals = {};
    Map<String, Color> categoryColors = {};
    Map<String, String> categoryIcons = {};
    Map<String, double> dayTotals = {};
    
    for (var t in transactions) {
      if (!t.transaction.isIncome) {
        totalSpent += t.transaction.amount;
        
        final catName = t.category.name;
        categoryTotals[catName] = (categoryTotals[catName] ?? 0) + t.transaction.amount;
        if (!categoryColors.containsKey(catName)) {
            // parse color from string or use default
            try {
              categoryColors[catName] = Color(int.parse(t.category.colorHex.replaceFirst('#', '0xFF')));
            } catch (e) {
              categoryColors[catName] = Colors.grey;
            }
            categoryIcons[catName] = t.category.icon;
        }
        
        final dateKey = DateFormat('yyyy-MM-dd').format(t.transaction.date);
        dayTotals[dateKey] = (dayTotals[dateKey] ?? 0) + t.transaction.amount;
      }
    }

    // Sort categories by amount descending
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Calculate daily average
    int days = 30;
    switch(timePeriod) {
      case '24H': days = 1; break;
      case '7D': days = 7; break;
      case '1M': days = 30; break;
      case '3M': days = 90; break;
      case '1Y': days = 365; break;
      case 'Custom': 
        final range = ref.read(analyticsCustomDateRangeProvider);
        if (range != null) {
          days = range.end.difference(range.start).inDays;
          if (days <= 0) days = 1;
        }
        break;
    }
    double dailyAvg = days > 0 ? totalSpent / days : totalSpent;

    // Calculate peak day
    String peakDayFormatted = '-';
    double peakDayAmount = 0;
    if (dayTotals.isNotEmpty) {
      final peakEntry = dayTotals.entries.reduce((a, b) => a.value > b.value ? a : b);
      peakDayFormatted = DateFormat('MMM d').format(DateTime.parse(peakEntry.key));
      peakDayAmount = peakEntry.value;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSelectors(context, ref, timePeriod, currentTracker),
          const SizedBox(height: 24),
          
          // Overview Section
          Row(
            children: [
              const Text(
                'Overview',
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.info_outline, color: Colors.grey, size: 18),
              const Spacer(),
              Text(
                '1 Trackers · ${timePeriod == '1M' ? '1M' : timePeriod}',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildOverviewCard('Total', formatter.format(totalSpent), Colors.white, Icons.pie_chart_outline)),
              const SizedBox(width: 8),
              Expanded(child: _buildOverviewCard('Daily Avg', formatter.format(dailyAvg), Colors.white, Icons.calendar_today)),
              const SizedBox(width: 8),
              Expanded(child: _buildOverviewCard('Peak Day', peakDayAmount > 0 ? formatter.format(peakDayAmount) : '-', Colors.white, Icons.local_fire_department, subText: peakDayFormatted != '-' ? peakDayFormatted : null)),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Categories Section
          const Text(
            'Categories',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: transactions.isEmpty || totalSpent == 0
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Text('No expenses in this period.', style: TextStyle(color: Colors.grey)),
                  ),
                )
              : Column(
                  children: [
                    // Pie chart and legend
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 140,
                          height: 140,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: sortedCategories.map((e) {
                                final color = categoryColors[e.key] ?? Colors.grey;
                                return PieChartSectionData(
                                  color: color,
                                  value: e.value,
                                  title: '',
                                  radius: 30, // Make it a bit thicker like a donut chart
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: sortedCategories.map((e) {
                              final percentage = ((e.value / totalSpent) * 100).toStringAsFixed(0);
                              final icon = categoryIcons[e.key] ?? '';
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    if (icon.isNotEmpty) ...[
                                      Text(icon, style: const TextStyle(fontSize: 14)),
                                      const SizedBox(width: 8),
                                    ] else ...[
                                      Icon(Icons.circle, color: categoryColors[e.key], size: 10),
                                      const SizedBox(width: 8),
                                    ],
                                    Expanded(
                                      child: Text(
                                        e.key,
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '$percentage%',
                                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Progress bars
                    ...sortedCategories.map((e) {
                      final color = categoryColors[e.key] ?? Colors.grey;
                      final percentage = e.value / totalSpent;
                      final icon = categoryIcons[e.key] ?? '';
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Row(
                          children: [
                            if (icon.isNotEmpty)
                              SizedBox(
                                width: 24,
                                child: Text(icon, style: const TextStyle(fontSize: 16)),
                              )
                            else
                              SizedBox(
                                width: 24,
                                child: Icon(Icons.circle, color: color, size: 12),
                              ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    formatter.format(e.value),
                                    style: const TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                  const SizedBox(height: 4),
                                  Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withAlpha(51), // approx 0.2 alpha
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: percentage,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
          ),
          
          const SizedBox(height: 32),
          
          // Trackers Comparison
          const Text(
            'Trackers Comparison',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentTracker?.name ?? 'Tracker', style: const TextStyle(color: Colors.white)),
                    Text(formatter.format(totalSpent), style: const TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.blue, 
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSelectors(BuildContext context, WidgetRef ref, String currentPeriod, ExpenseTracker? currentTracker) {
    return Row(
      children: [
        // Dropdown for period
        PopupMenuButton<String>(
          initialValue: currentPeriod,
          color: const Color(0xFF2C2C2E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          onSelected: (val) {
            ref.read(analyticsTimePeriodProvider.notifier).state = val;
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(value: '24H', child: Text('Last 24 hours', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(value: '7D', child: Text('Last 7 days', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(value: '1M', child: Text('Last 30 days', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(value: '3M', child: Text('Last 3 months', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(value: '1Y', child: Text('Last 12 months', style: TextStyle(color: Colors.white))),
            const PopupMenuItem(value: 'Custom', child: Text('Custom Range', style: TextStyle(color: Colors.white))),
          ],
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getDisplayPeriod(currentPeriod),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Tracker pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E), 
            border: Border.all(color: Colors.blue.withAlpha(128)), // approx 0.5 alpha
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.blue, size: 16),
              const SizedBox(width: 6),
              Text(
                currentTracker?.name ?? 'Tracker',
                style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getDisplayPeriod(String period) {
    switch (period) {
      case '24H': return 'Last 24 hours';
      case '7D': return 'Last 7 days';
      case '1M': return 'Last 30 days';
      case '3M': return 'Last 3 months';
      case '1Y': return 'Last 12 months';
      case 'Custom': return 'Custom Range';
      default: return 'Last 30 days';
    }
  }

  Widget _buildOverviewCard(String title, String value, Color valueColor, IconData icon, {String? subText}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey, size: 14),
              const SizedBox(width: 4),
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(color: valueColor, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            subText ?? '- 0%', // Default placeholder for percentage
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
