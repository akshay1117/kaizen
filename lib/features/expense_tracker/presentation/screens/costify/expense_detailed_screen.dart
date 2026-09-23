import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_dao.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';
import 'package:drift/drift.dart' as drift;

class _Colors {
  static const Color surface = Color(0xFF121318);
  static const Color surfaceContainerLowest = Color(0xFF0D0E13);
  static const Color surfaceContainerLow = Color(0xFF1A1B21);
  static const Color surfaceContainer = Color(0xFF1E1F25);
  static const Color surfaceContainerHigh = Color(0xFF292A2F);
  static const Color surfaceContainerHighest = Color(0xFF34343A);
  
  static const Color onSurface = Color(0xFFE3E1E9);
  static const Color onSurfaceVariant = Color(0xFFCBC3D7);
  static const Color outline = Color(0xFF958EA0);
  static const Color outlineVariant = Color(0xFF494454);
  
  static const Color primary = Color(0xFFD0BCFF);
  static const Color onPrimary = Color(0xFF3C0091);
  static const Color primaryContainer = Color(0xFFA078FF);
  static const Color secondary = Color(0xFFCEBDFF);
  static const Color secondaryContainer = Color(0xFF4F319C);
  static const Color tertiary = Color(0xFF7BD0FF);
}

class ExpenseDetailedScreen extends ConsumerStatefulWidget {
  const ExpenseDetailedScreen({super.key});

  @override
  ConsumerState<ExpenseDetailedScreen> createState() => _ExpenseDetailedScreenState();
}

class _ExpenseDetailedScreenState extends ConsumerState<ExpenseDetailedScreen> {
  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _ExpenseModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(analyticsTransactionsProvider);

    return Scaffold(
      backgroundColor: _Colors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _Colors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Atmospheric Glow
          Positioned(
            top: -24,
            left: MediaQuery.of(context).size.width / 2 - 128,
            child: Container(
              width: 256,
              height: 144,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    _Colors.primaryContainer.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
              // No child needed, the gradient creates the glow
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: AppSpacing.sm),
                  _buildTimeRangeSelector(),
                  const SizedBox(height: AppSpacing.md),
                  transactionsAsync.when(
                    data: (transactions) => Column(
                      children: [
                        _buildPrimarySummaryCard(transactions),
                        const SizedBox(height: AppSpacing.md),
                        _buildHistogramCard(transactions),
                        const SizedBox(height: AppSpacing.md),
                        _buildRecentTransactionsCard(transactions),
                      ],
                    ),
                    loading: () => const Center(child: CircularProgressIndicator(color: _Colors.primary)),
                    error: (error, stack) => Center(child: Text('Error: $error', style: const TextStyle(color: Colors.red))),
                  ),
                  const SizedBox(height: 80), // Padding for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: GestureDetector(
        onTap: _showAddExpenseModal,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: _Colors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: _Colors.primaryContainer.withValues(alpha: 0.35),
                blurRadius: 18,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Icon(Icons.add, color: _Colors.onPrimary, size: 28),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Row(
            children: [
              Icon(Icons.calendar_month, color: _Colors.primary, size: 18),
              SizedBox(width: AppSpacing.sm),
              Text(
                'October 2024',
                style: TextStyle(
                  color: _Colors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Inter',
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Icon(Icons.expand_more, color: _Colors.outline, size: 16),
            ],
          ),
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _Colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_left, color: _Colors.onSurfaceVariant, size: 16),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: _Colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.chevron_right, color: _Colors.onSurfaceVariant, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    final selectedPeriod = ref.watch(analyticsTimePeriodProvider);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTimeButton('Today', '24H', selectedPeriod),
          _buildTimeButton('Week', '7D', selectedPeriod),
          _buildTimeButton('Month', '1M', selectedPeriod),
          _buildTimeButton('Year', '1Y', selectedPeriod),
        ],
      ),
    );
  }

  Widget _buildTimeButton(String title, String periodValue, String selectedPeriod) {
    final isSelected = selectedPeriod == periodValue;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(analyticsTimePeriodProvider.notifier).state = periodValue;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: isSelected
              ? BoxDecoration(
                  color: _Colors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    )
                  ],
                )
              : null,
          alignment: Alignment.center,
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: isSelected ? _Colors.primary : _Colors.onSurfaceVariant,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
              letterSpacing: 0.06 * 11,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimarySummaryCard(List<TransactionWithDetails> transactions) {
    // 1. Filter expenses
    final expenses = transactions.where((t) => !t.transaction.isIncome).toList();
    
    // 2. Aggregate by category
    final Map<String, double> categoryTotals = {};
    final Map<String, ExpenseCategory> categoryMap = {};
    double totalExpense = 0;

    for (final t in expenses) {
      final catName = t.category.name;
      final amount = t.transaction.amount;
      categoryTotals[catName] = (categoryTotals[catName] ?? 0) + amount;
      categoryMap[catName] = t.category;
      totalExpense += amount;
    }

    // 3. Create sorted list
    final sortedCats = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // 4. Create CategoryChartData
    final palette = [
      _Colors.primary,
      _Colors.primaryContainer,
      _Colors.secondary,
      _Colors.secondaryContainer,
      _Colors.tertiary,
      _Colors.outlineVariant,
    ];

    final chartData = <CategoryChartData>[];
    for (int i = 0; i < sortedCats.length; i++) {
      final entry = sortedCats[i];
      final cat = categoryMap[entry.key]!;
      final percentage = totalExpense > 0 ? (entry.value / totalExpense) : 0.0;
      final color = palette[i % palette.length];
      
      chartData.add(CategoryChartData(
        title: cat.name,
        iconStr: cat.icon,
        amount: entry.value,
        percentage: percentage,
        color: color,
      ));
    }

    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CATEGORY ALLOCATION',
                    style: TextStyle(
                      color: _Colors.outline,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.06 * 11,
                    ),
                  ),
                  Text(
                    'Spending Spread',
                    style: TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _Colors.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.arrow_downward, color: _Colors.tertiary, size: 14),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '3.8% vs Sep',
                      style: TextStyle(
                        color: _Colors.tertiary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.06 * 11,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Donut Chart
          Center(
            child: SizedBox(
              width: 192,
              height: 192,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Transform.rotate(
                      angle: -math.pi / 2,
                      child: CustomPaint(
                        painter: _DonutChartPainter(chartData),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'TOTAL SPENT',
                        style: TextStyle(
                          color: _Colors.outline,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.06 * 11,
                        ),
                      ),
                      Text(
                        currencyFormat.format(totalExpense),
                        style: const TextStyle(
                          color: _Colors.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${chartData.length} Categories',
                        style: const TextStyle(
                          color: _Colors.primary,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...chartData.map((data) {
            return _buildCategoryItem(
              iconStr: data.iconStr,
              iconColor: data.color,
              bgColor: data.color.withValues(alpha: 0.15),
              title: data.title,
              subtitle: '${(data.percentage * 100).toStringAsFixed(1)}% of total',
              amount: currencyFormat.format(data.amount),
              barColor: data.color,
              percentage: data.percentage,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryItem({
    required String iconStr,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String amount,
    required Color barColor,
    required double percentage,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    iconStr,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _Colors.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: _Colors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: _Colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(2),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 48 * percentage,
                  height: 4,
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistogramCard(List<TransactionWithDetails> transactions) {
    final dateRange = ref.watch(analyticsDateRangeProvider);
    final start = dateRange?.start ?? DateTime.now().subtract(const Duration(days: 7));
    final end = dateRange?.end ?? DateTime.now();
    final duration = end.difference(start);
    // Add a tiny bit to duration to avoid index out of bounds on exactly end time
    final bucketDuration = Duration(milliseconds: (duration.inMilliseconds + 1) ~/ 7);

    List<double> bucketTotals = List.filled(7, 0.0);
    List<String> bucketLabels = [];

    // Format labels
    for (int i = 0; i < 7; i++) {
       final bucketStart = start.add(bucketDuration * i);
       if (duration.inDays <= 1) {
          bucketLabels.add(DateFormat('ha').format(bucketStart)); // 3AM
       } else if (duration.inDays <= 7) {
          bucketLabels.add(DateFormat('E').format(bucketStart).substring(0, 1)); // M, T, W
       } else if (duration.inDays <= 31) {
          bucketLabels.add(DateFormat('d').format(bucketStart)); // 1, 5, 9
       } else {
          bucketLabels.add(DateFormat('MMM').format(bucketStart).substring(0, 1)); // J, F, M
       }
    }

    final expenses = transactions.where((t) => !t.transaction.isIncome).toList();
    for (final t in expenses) {
       final date = t.transaction.date;
       if (date.isBefore(start) || date.isAfter(end)) continue;
       
       int bucketIndex = date.difference(start).inMilliseconds ~/ bucketDuration.inMilliseconds;
       if (bucketIndex >= 7) bucketIndex = 6;
       if (bucketIndex < 0) bucketIndex = 0;
       
       bucketTotals[bucketIndex] += t.transaction.amount;
    }

    double maxTotal = 0;
    double sumTotal = 0;
    int peakIndex = 0;
    for (int i = 0; i < 7; i++) {
      sumTotal += bucketTotals[i];
      if (bucketTotals[i] > maxTotal) {
        maxTotal = bucketTotals[i];
        peakIndex = i;
      }
    }
    
    final average = sumTotal / 7;
    final compactFormat = NumberFormat.compact(locale: 'en_IN');
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SPENDING CADENCE',
                    style: TextStyle(
                      color: _Colors.outline,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.06 * 11,
                    ),
                  ),
                  Text(
                    'Histogram',
                    style: TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 144,
            child: Stack(
              children: [
                // Average Line
                Positioned(
                  bottom: 56, // matching bottom-14 (56px) in tailwind
                  left: 0,
                  right: 0,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: _Colors.outlineVariant.withValues(alpha: 0.6), // roughly border-dashed
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        color: _Colors.surfaceContainerLow,
                        child: Text(
                          'Avg ${currencyFormat.format(average)}',
                          style: const TextStyle(
                            color: _Colors.outline,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.06 * 9,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Bars
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (i) {
                       final isGlow = i == peakIndex && bucketTotals[i] > 0;
                       final height = maxTotal > 0 ? (bucketTotals[i] / maxTotal) * 118 : 0.0;
                       return _buildHistogramBar(
                          maxTotal > 0 ? compactFormat.format(bucketTotals[i]) : '0', 
                          bucketLabels[i], 
                          height < 4 ? 4 : height, // min height
                          isGlow ? _Colors.primary : _Colors.surfaceContainerHighest, 
                          isGlow
                       );
                    }),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHistogramBar(String value, String label, double height, Color color, bool isGlow) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: isGlow ? _Colors.primary : _Colors.onSurfaceVariant,
            fontSize: 9,
            fontWeight: isGlow ? FontWeight.bold : FontWeight.w600,
            letterSpacing: 0.06 * 9,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: 32,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            boxShadow: isGlow
                ? [
                    BoxShadow(
                      color: _Colors.primary.withValues(alpha: 0.6),
                      blurRadius: 14,
                    )
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: isGlow ? _Colors.primary : _Colors.outline,
            fontSize: 11,
            fontWeight: isGlow ? FontWeight.bold : FontWeight.w600,
            letterSpacing: 0.06 * 11,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsCard(List<TransactionWithDetails> transactions) {
    final sortedTransactions = List<TransactionWithDetails>.from(transactions)
      ..sort((a, b) => b.transaction.date.compareTo(a.transaction.date));
    
    final displayTransactions = sortedTransactions.take(5).toList();
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RECENT ACTIVITY',
                    style: TextStyle(
                      color: _Colors.outline,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.06 * 11,
                    ),
                  ),
                  Text(
                    'Transactions Ledger',
                    style: TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (displayTransactions.isEmpty)
             const Padding(
               padding: EdgeInsets.all(16.0),
               child: Center(
                 child: Text(
                   'No recent activity',
                   style: TextStyle(color: _Colors.onSurfaceVariant),
                 ),
               ),
             ),
          ...displayTransactions.map((t) {
            final isIncome = t.transaction.isIncome;
            final palette = [
              _Colors.primary,
              _Colors.primaryContainer,
              _Colors.secondary,
              _Colors.secondaryContainer,
              _Colors.tertiary,
              _Colors.outlineVariant,
            ];
            final color = palette[t.category.name.hashCode.abs() % palette.length];
            
            String dateStr = DateFormat('MMM d, h:mm a').format(t.transaction.date);
            String amountStr = currencyFormat.format(t.transaction.amount);
            if (!isIncome) {
              amountStr = '-$amountStr';
            } else {
              amountStr = '+$amountStr';
            }

            return _buildTransactionItem(
              iconStr: t.category.icon,
              iconColor: color,
              bgColor: color.withValues(alpha: 0.2),
              title: t.transaction.note ?? t.category.name,
              subtitle: '$dateStr · ${t.category.name}',
              amount: amountStr,
              status: isIncome ? 'Income' : 'Settled',
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTransactionItem({
    required String iconStr,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required String amount,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: _Colors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
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
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    iconStr,
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _Colors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: const TextStyle(
                  color: _Colors.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                status,
                style: const TextStyle(
                  color: _Colors.outline,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.06 * 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryChartData {
  final String title;
  final String iconStr;
  final double amount;
  final double percentage;
  final Color color;

  CategoryChartData({
    required this.title,
    required this.iconStr,
    required this.amount,
    required this.percentage,
    required this.color,
  });
}

class _DonutChartPainter extends CustomPainter {
  final List<CategoryChartData> data;

  _DonutChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 7;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..color = _Colors.surfaceContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14;
    canvas.drawCircle(center, radius, bgPaint);

    double startAngle = 0; // The transform in widget rotates it -90 deg anyway.
    
    void drawSegment(Color color, double value, double total) {
      final sweepAngle = (value / total) * 2 * math.pi;
      final segmentPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(rect, startAngle, sweepAngle, false, segmentPaint);
      startAngle += sweepAngle;
    }

    for (final item in data) {
      drawSegment(item.color, item.percentage * 100, 100);
    }
  }

  @override
  bool shouldRepaint(covariant _DonutChartPainter oldDelegate) {
    return true; // Simple approach to ensure it repaints when data changes
  }
}

// Modal logic
class _ExpenseModal extends ConsumerStatefulWidget {
  const _ExpenseModal();

  @override
  ConsumerState<_ExpenseModal> createState() => _ExpenseModalState();
}

class _ExpenseModalState extends ConsumerState<_ExpenseModal> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  ExpenseCategory? _selectedCategory;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _Colors.surfaceContainerLow,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: _Colors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TELEMETRY INPUT',
                    style: TextStyle(
                      color: _Colors.outline,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.06 * 11,
                    ),
                  ),
                  Text(
                    'Log Expense',
                    style: TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: _Colors.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: _Colors.onSurfaceVariant, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          // Amount Input
          const Text(
            'AMOUNT',
            style: TextStyle(
              color: _Colors.outline,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _Colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  '₹',
                  style: TextStyle(
                    color: _Colors.primary,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    autofocus: true,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    style: const TextStyle(
                      color: _Colors.onSurface,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: '0.00',
                      hintStyle: TextStyle(
                        color: _Colors.outline,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Category Pills
          const Text(
            'CATEGORY',
            style: TextStyle(
              color: _Colors.outline,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 11,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Consumer(builder: (context, ref, _) {
              final categoriesAsync = ref.watch(categoriesProvider);
              final categories = categoriesAsync.valueOrNull ?? [];
              if (categories.isEmpty) return const SizedBox();
              
              return Row(
                children: categories.map((cat) {
                  final isSelected = _selectedCategory?.id == cat.id || 
                    (_selectedCategory == null && cat.id == categories.first.id);
                    
                  if (isSelected && _selectedCategory == null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted && _selectedCategory == null) {
                         setState(() => _selectedCategory = cat);
                      }
                    });
                  }
                  
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: _buildCategoryPill('${cat.icon} ${cat.name}', isSelected),
                  );
                }).toList(),
              );
            }),
          ),
          const SizedBox(height: AppSpacing.md),
          // Description
          const Text(
            'DESCRIPTION',
            style: TextStyle(
              color: _Colors.outline,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.06 * 11,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: _Colors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _noteController,
              style: const TextStyle(color: _Colors.onSurface, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'e.g. Organic Matcha Latte',
                hintStyle: TextStyle(color: _Colors.outline),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _Colors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: _Colors.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final dao = ref.read(expenseDaoProvider);
                    final amountVal = double.tryParse(_amountController.text) ?? 0.0;
                    if (amountVal <= 0) return;
                    
                    final currentTrackerId = ref.read(selectedTrackerIdProvider);
                    final catId = _selectedCategory?.id;
                    if (catId == null) return;
                    
                    final newExpense = ExpenseTransactionsCompanion.insert(
                      amount: amountVal,
                      date: DateTime.now(),
                      isIncome: const drift.Value(false),
                      categoryId: catId,
                      trackerId: currentTrackerId != null ? drift.Value(currentTrackerId) : const drift.Value.absent(),
                      note: _noteController.text.isNotEmpty ? drift.Value(_noteController.text) : const drift.Value.absent(),
                    );
                    
                    await dao.insertTransaction(newExpense);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _Colors.primary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _Colors.primary.withValues(alpha: 0.4),
                          blurRadius: 16,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Save Expense',
                      style: TextStyle(
                        color: _Colors.onPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPill(String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? _Colors.primary : _Colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? _Colors.onPrimary : _Colors.onSurfaceVariant,
          fontSize: 11,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
        ),
      ),
    );
  }
}
