import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:intl/intl.dart';
import '../../application/expense_providers.dart';

class ExpenseAnalyticsScreen extends ConsumerStatefulWidget {
  const ExpenseAnalyticsScreen({super.key});

  @override
  ConsumerState<ExpenseAnalyticsScreen> createState() =>
      _ExpenseAnalyticsScreenState();
}

class _ExpenseAnalyticsScreenState
    extends ConsumerState<ExpenseAnalyticsScreen> {

  @override
  Widget build(BuildContext context) {
    // We can use the filtered transactions provider, but here let's just fetch all or filter locally
    // to give analytics for the selected period independently of the home screen.
    // For simplicity, we'll watch the main provider and just override the state, or better yet:
    final transactionsAsync = ref.watch(filteredTransactionsProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const GlassAppBar(
        backgroundColor: Colors.black,
        title: Text('Analytics',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: SafeArea(
        child: transactionsAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: Color(0xFF0A84FF))),
          error: (err, stack) => Center(
              child: Text('Error: $err',
                  style: const TextStyle(color: Colors.red))),
          data: (transactions) {
            if (transactions.isEmpty) {
              return const Center(
                  child: Text('No data for this period.',
                      style: TextStyle(color: Colors.white)));
            }

            final expenses =
                transactions.where((t) => !t.transaction.isIncome).toList();
            final double totalExpense =
                expenses.fold(0, (sum, t) => sum + t.transaction.amount);

            // Group by category
            final Map<String, double> categoryTotals = {};
            final Map<String, String> categoryColors = {};
            for (var t in expenses) {
              categoryTotals[t.category.name] =
                  (categoryTotals[t.category.name] ?? 0) + t.transaction.amount;
              categoryColors[t.category.name] = t.category.colorHex;
            }

            final sortedCategories = categoryTotals.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));

            // Group by date for trend chart (last 30 days)
            final Map<String, double> dailyTotals = {};
            for (var t in expenses) {
              final dateStr =
                  DateFormat('yyyy-MM-dd').format(t.transaction.date);
              dailyTotals[dateStr] =
                  (dailyTotals[dateStr] ?? 0) + t.transaction.amount;
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                          child: _buildStatCard(
                              'Total Spent',
                              '₹${totalExpense.toStringAsFixed(2)}',
                              Colors.white)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Daily Avg',
                          '₹${(totalExpense / (dailyTotals.isNotEmpty ? dailyTotals.length : 1)).toStringAsFixed(2)}',
                          const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Category Breakdown Header
                  const Text('Categories',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Pie Chart + Progress Bars Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Pie Chart
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 0,
                            centerSpaceRadius: 0,
                            sections: sortedCategories.map((cat) {
                              final percentage = (cat.value / totalExpense) * 100;
                              final color = Color(int.parse(categoryColors[cat.key] ?? 'FFFFFFFF', radix: 16));
                              return PieChartSectionData(
                                color: color,
                                value: percentage,
                                radius: 70,
                                showTitle: false,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Progress Bars
                      Expanded(
                        child: Column(
                          children: sortedCategories.map((cat) {
                            final percentage = (cat.value / totalExpense) * 100;
                            final color = Color(int.parse(categoryColors[cat.key] ?? 'FFFFFFFF', radix: 16));
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  // Simplified icon for now, ideally find the emoji
                                  Icon(Icons.circle, size: 12, color: color),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      cat.key,
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${percentage.toStringAsFixed(0)}%',
                                    style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Progress bars visual representation
                  ...sortedCategories.map((cat) {
                    final color = Color(int.parse(categoryColors[cat.key] ?? 'FFFFFFFF', radix: 16));
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: cat.value / (sortedCategories.first.value), // Relative to max
                              backgroundColor: const Color(0xFF2C2C2E),
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                              borderRadius: BorderRadius.circular(8),
                              minHeight: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: 80,
                            child: Text(
                              '₹${cat.value.toStringAsFixed(2)}',
                              style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(height: 32),
                  
                  // Pro Locked Cards
                  _buildLockedProCard('Spending Trend', 'Unlock detailed spending trends over time.'),
                  const SizedBox(height: 16),
                  _buildLockedProCard('Smart Insights', 'Get personalized insights and saving tips.'),
                  const SizedBox(height: 16),
                  _buildLockedProCard('Budget Status', 'Track budgets and remaining limits.'),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String amount, Color amountColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14)),
          const SizedBox(height: 8),
          Text(amount,
              style: TextStyle(
                  color: amountColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildLockedProCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.lock, color: Colors.white, size: 24),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A84FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              ),
              child: const Text('Upgrade to Pro', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
