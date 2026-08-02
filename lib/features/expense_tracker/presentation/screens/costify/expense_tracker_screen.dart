import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/add_expense_modal.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/quick_actions_sheet.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/expense_detail_view.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/tracker_drawer.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/donut_chart_widget.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/new_tracker_modal.dart';

class ExpenseTrackerScreen extends ConsumerStatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  ConsumerState<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends ConsumerState<ExpenseTrackerScreen> {
  final List<String> _periods = ['24H', '7D', '1M', '3M', '1Y', 'Custom'];

  void _showAddExpenseModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddExpenseModal(),
    );
  }

  void _showQuickActions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => const QuickActionsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentTrackerAsync = ref.watch(currentTrackerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      drawer: const TrackerDrawer(),
      body: currentTrackerAsync.when(
        data: (tracker) {
          if (tracker == null) {
            return SafeArea(
              child: Column(
                children: [
                  _buildAppBar(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet_outlined, size: 64, color: Colors.white.withValues(alpha: 0.2)),
                          const SizedBox(height: 16),
                          const Text(
                            'No trackers found',
                            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Create a tracker to start managing your expenses.',
                            style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Padding(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: const NewTrackerModal(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0A84FF),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Create Tracker', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Stack(
            children: [
              SafeArea(
                child: Column(
                  children: [
                    _buildAppBar(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            const DonutChartWidget(),
                            const SizedBox(height: 24),
                            _buildTimePeriodSelector(),
                            const SizedBox(height: 24),
                            _buildCategoryChips(),
                            const SizedBox(height: 16),
                            _buildExpenseList(),
                            const SizedBox(height: 200), // padding for FABs
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Bottom FABs
              Positioned(
                bottom: 120,
                left: 24,
                child: FloatingActionButton(
                  heroTag: 'quick_actions_fab',
                  backgroundColor: const Color(0xFF1C1C1E),
                  onPressed: _showQuickActions,
                  child: const Icon(Icons.grid_view, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 120,
                right: 24,
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: FloatingActionButton(
                    heroTag: 'add_expense_fab',
                    backgroundColor: const Color(0xFF1C1C1E),
                    onPressed: _showAddExpenseModal,
                    child: const Icon(Icons.add, color: Colors.white, size: 32),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1E),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.wallet, color: Colors.white, size: 20),
          ),
          const Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF1C1C1E),
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
              SizedBox(width: 8),
              CircleAvatar(
                radius: 16,
                backgroundColor: Color(0xFF1C1C1E),
                child: Icon(Icons.person_outline, color: Colors.white, size: 16),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) return const SizedBox(height: 40);

        final categoryTotals = <String, double>{};
        final categoryColors = <String, Color>{};
        final categoryIcons = <String, String>{};

        for (final t in transactions) {
          if (!t.transaction.isIncome) {
            final catName = t.category.name;
            categoryTotals[catName] = (categoryTotals[catName] ?? 0) + t.transaction.amount;
            
            String hex = t.category.colorHex;
            if (hex.length == 6) hex = 'FF$hex';
            categoryColors[catName] = Color(int.parse(hex, radix: 16));
            
            categoryIcons[catName] = t.category.icon;
          }
        }

        final sortedCategories = categoryTotals.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

        return SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: sortedCategories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = sortedCategories[index];
              final color = categoryColors[cat.key] ?? Colors.grey;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${cat.key} ${formatter.format(cat.value)}',
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: 40),
    );
  }

  Widget _buildTimePeriodSelector() {
    final selectedPeriod = ref.watch(selectedTimePeriodProvider);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _periods.map((period) {
          final isActive = selectedPeriod == period;
          return GestureDetector(
            onTap: () => ref.read(selectedTimePeriodProvider.notifier).state = period,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF1C1C1E) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xFF8E8E93),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseList() {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(32.0),
            child: Center(
              child: Text(
                'No expenses during the selected period.',
                style: TextStyle(color: Color(0xFF8E8E93)),
              ),
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final t = transactions[index];
            final dateStr = DateFormat('MMMM d, yyyy').format(t.transaction.date);
            final isIncome = t.transaction.isIncome;
            final amountColor = isIncome ? const Color(0xFF34C759) : const Color(0xFFFF3B30);
            
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExpenseDetailView(
                    title: t.transaction.note ?? t.category.name,
                    amount: formatter.format(t.transaction.amount),
                    category: t.category.name,
                    date: dateStr,
                    onDelete: () async {
                      final dao = ref.read(expenseDaoProvider);
                      await dao.deleteTransaction(t.transaction);
                      if (context.mounted) Navigator.pop(context);
                    },
                  )),
                );
              },
              title: Text(t.transaction.note ?? t.category.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
              subtitle: Text('${t.category.name} • $dateStr', style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatter.format(t.transaction.amount),
                    style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: Color(0xFF8E8E93)),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
    );
  }
}
