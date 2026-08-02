import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'expense_detail_screen.dart';
import '../widgets/expense_donut_chart.dart';
import '../widgets/expense_category_chip.dart';
import '../widgets/expense_time_period_selector.dart';
import '../widgets/expense_list_tile.dart';
import '../widgets/add_expense_modal.dart';
import '../widgets/quick_actions_bottom_sheet.dart';
import '../widgets/expense_tracker_drawer.dart';
import '../../application/expense_providers.dart';
import 'package:intl/intl.dart';

class ExpenseTrackerScreen extends ConsumerStatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  ConsumerState<ExpenseTrackerScreen> createState() =>
      _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends ConsumerState<ExpenseTrackerScreen> {
  final List<String> _periods = ['24H', '7D', '1M', '3M', '1Y', 'Custom'];

  void _openAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.9,
        child: const AddExpenseModal(),
      ),
    );
  }

  void _openQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickActionsBottomSheet(),
    );
  }

  Future<void> _selectCustomDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF0A84FF),
              onPrimary: Colors.white,
              surface: Color(0xFF1C1C1E),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF121212)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(customDateRangeProvider.notifier).state = (
        start: picked.start,
        end: DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59, 999),
      );
      ref.read(selectedTimePeriodProvider.notifier).state = 'Custom';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = ref.watch(selectedTimePeriodProvider);
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final membersAsync = ref.watch(membersForSelectedTrackerProvider);
    final currencyFmt = ref.watch(currencyFormatterProvider);
    final int memberCount = membersAsync.maybeWhen(
      data: (members) => members.isNotEmpty ? members.length : 1,
      orElse: () => 1,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D12), // Deep dark base
      drawer: const ExpenseTrackerDrawer(),
      body: Stack(
        children: [
          // Ambient blurred gradient background
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0A84FF).withValues(alpha: 0.15),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF0A84FF).withValues(alpha: 0.15), blurRadius: 100, spreadRadius: 100),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                Column(
                  children: [
                // Custom App Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Far Left: Circular dark grey hamburger menu
                      Builder(
                        builder: (context) => GestureDetector(
                          onTap: () => Scaffold.of(context).openDrawer(),
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1C1C1E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.menu, color: Colors.white),
                          ),
                        ),
                      ),
                      // Center: Avatar initials
                      Container(
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF3A3A3C), width: 1),
                        ),
                        child: const Text('AN', style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      // Far Right: Profile and Tracker Icon
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1C1C1E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1C1C1E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.public, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Hero Section: Chart & Totals
                        // Chart Hero Section
                        transactionsAsync.when(
                          loading: () => const SizedBox(
                            height: 250,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                      color: Color(0xFF3A3A3C)),
                                  SizedBox(height: 16),
                                  Text('Loading...',
                                      style: TextStyle(
                                          color: Color(0xFF8E8E93),
                                          fontSize: 16)),
                                ],
                              ),
                            ),
                          ),
                          error: (err, stack) => SizedBox(
                            height: 250,
                            child: Center(
                                child: Text('Error: $err',
                                    style: const TextStyle(color: Colors.red))),
                          ),
                          data: (transactions) {
                            final double total = transactions.fold(0,
                                (sum, item) => sum + item.transaction.amount);
                            final bool isEmpty = transactions.isEmpty;
                            final int days = selectedPeriod == '24H'
                                ? 1
                                : selectedPeriod == '7D'
                                    ? 7
                                    : selectedPeriod == '1M'
                                        ? 30
                                        : selectedPeriod == '3M'
                                            ? 90
                                            : selectedPeriod == '1Y'
                                                ? 365
                                                : 30;

                            // Calculate category totals for pie chart
                            final Map<String, double> categoryTotals = {};
                            final Map<String, String> categoryColors = {};
                            for (var t in transactions) {
                              if (!t.transaction.isIncome) {
                                categoryTotals[t.category.name] =
                                    (categoryTotals[t.category.name] ?? 0) +
                                        t.transaction.amount;
                                categoryColors[t.category.name] =
                                    t.category.colorHex;
                              }
                            }

                            final List<PieChartSectionData> sections = [];
                            if (!isEmpty) {
                              categoryTotals.forEach((name, amount) {
                                final percentage = (amount / total) * 100;
                                final color = Color(int.parse(
                                    'FF${categoryColors[name] ?? 'FFFFFF'}',
                                    radix: 16));
                                sections.add(PieChartSectionData(
                                    color: color,
                                    value: percentage,
                                    showTitle: false,
                                    radius: 20));
                              });
                            }

                            return SizedBox(
                              height: 250,
                              child: ExpenseDonutChart(
                                periodText: 'Last $selectedPeriod',
                                totalAmount: currencyFmt.format(total),
                                averagePerDay:
                                    currencyFmt.format(total / days),
                                averagePerPerson:
                                    currencyFmt.format(total / memberCount),
                                sections: isEmpty ? [] : sections,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Category Chips
                        transactionsAsync.maybeWhen(
                          data: (transactions) {
                            if (transactions.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            // Group by category to show chips
                            final Map<String, Map<String, dynamic>> catData =
                                {};
                            for (var t in transactions) {
                              if (!t.transaction.isIncome) {
                                final name = t.category.name;
                                if (!catData.containsKey(name)) {
                                  catData[name] = {
                                    'amount': 0.0,
                                    'emoji': t.category.icon,
                                    'color': t.category.colorHex
                                  };
                                }
                                catData[name]!['amount'] +=
                                    t.transaction.amount;
                              }
                            }

                            final sortedCat = catData.entries.toList()
                              ..sort((a, b) => (b.value['amount'] as double)
                                  .compareTo(a.value['amount'] as double));

                            return Column(
                              children: [
                                SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: sortedCat.length,
                                    itemBuilder: (context, index) {
                                      final item = sortedCat[index];
                                      final color = Color(int.parse(
                                          item.value['color'] as String,
                                          radix: 16));
                                      return ExpenseCategoryChip(
                                        emoji: item.value['emoji'] as String,
                                        name: item.key,
                                        amount: currencyFmt.format(item.value['amount'] as double),
                                        backgroundColor: color,
                                        textColor:
                                            color.computeLuminance() > 0.5
                                                ? Colors.black
                                                : Colors.white,
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],
                            );
                          },
                          orElse: () => const SizedBox.shrink(),
                        ),

                        // Time Period Selector
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1C1C1E),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: ExpenseTimePeriodSelector(
                            periods: _periods,
                            selectedPeriod: selectedPeriod,
                            onPeriodSelected: (period) {
                              if (period == 'Custom') {
                                _selectCustomDateRange(context);
                              } else {
                                ref
                                    .read(selectedTimePeriodProvider.notifier)
                                    .state = period;
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Empty State or Expense List
                        transactionsAsync.maybeWhen(
                          data: (transactions) {
                            if (transactions.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 32),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1C1C1E),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Center(
                                  child: Text(
                                    'No expenses during the selected period.',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                ),
                              );
                            }

                            return Column(
                              children: [
                                  ...transactions.map((t) => Column(
                                        children: [
                                          Dismissible(
                                            key: ValueKey(t.transaction.id),
                                            direction: DismissDirection.endToStart,
                                            background: Container(
                                              alignment: Alignment.centerRight,
                                              padding: const EdgeInsets.only(right: 20.0),
                                              color: Colors.red,
                                              child: const Icon(Icons.delete, color: Colors.white),
                                            ),
                                            onDismissed: (direction) async {
                                              try {
                                                final dao = ref.read(expenseDaoProvider);
                                                final count = await dao.deleteTransaction(t.transaction);
                                                if (count > 0 && context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Transaction deleted')),
                                                  );
                                                } else {
                                                  debugPrint('Delete failed, 0 rows affected');
                                                }
                                              } catch (e, st) {
                                                debugPrint('Error deleting transaction: $e\n$st');
                                              }
                                            },
                                            child: ExpenseListTile(
                                              username:
                                                  'User', // TODO: Get actual user
                                              title:
                                                  t.transaction.note?.isNotEmpty ==
                                                          true
                                                      ? t.transaction.note!
                                                      : t.category.name,
                                              subtitle:
                                                  '${t.category.name}\n${DateFormat('MMMM d, yyyy').format(t.transaction.date)}',
                                              amount: currencyFmt.format(t.transaction.amount),
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ExpenseDetailScreen(
                                                          transactionData: t)),
                                            );
                                          },
                                        ),
                                      ),
                                        const Divider(
                                            color: Color(0xFF2C2C2E),
                                            height: 1),
                                      ],
                                    )),
                                const SizedBox(height: 140),
                              ],
                            );
                          },
                          orElse: () => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Custom FABs
            Positioned(
              left: 24,
              bottom: 140,
              child: SizedBox(
                width: 56,
                height: 56,
                child: FloatingActionButton(
                  heroTag: 'grid_fab',
                  onPressed: _openQuickActions,
                  backgroundColor: const Color(0xFF1C1C1E),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  child: const Icon(Icons.grid_view, color: Colors.white),
                ),
              ),
            ),
            Positioned(
              right: 24,
              bottom: 140,
              child: SizedBox(
                width: 64,
                height: 64,
                child: FloatingActionButton(
                  heroTag: 'add_fab',
                  onPressed: _openAddExpenseModal,
                  backgroundColor: const Color(0xFF1C1C1E),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
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
}
