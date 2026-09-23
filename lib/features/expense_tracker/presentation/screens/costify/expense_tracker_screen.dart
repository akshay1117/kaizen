import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/add_expense_modal.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/quick_actions_sheet.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/tracker_drawer.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/donut_chart_widget.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/new_tracker_modal.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/expense_detailed_screen.dart';

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
                          Icon(Icons.account_balance_wallet_outlined, size: 64, color: AppColors.textPrimary.withValues(alpha: 0.2)),
                          const SizedBox(height: AppSpacing.md),
                          const Text(
                            'No trackers found',
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          const Text(
                            'Create a tracker to start managing your expenses.',
                            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                          ),
                          const SizedBox(height: AppSpacing.lg),
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
                              backgroundColor: AppColors.accentViolet,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Create Tracker', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.md),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ExpenseDetailedScreen(),
                              ),
                            );
                          },
                          child: const DonutChartWidget(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _buildTimePeriodSelector(),
                        const SizedBox(height: AppSpacing.lg),
                        _buildCategoryChips(),
                        const SizedBox(height: AppSpacing.md),
                        _buildExpenseList(),
                        const SizedBox(height: 100), // padding for bottom nav
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.semanticUrgent))),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0, left: 24.0, right: 24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'quick_actions_fab',
              backgroundColor: AppColors.surfaceObsidian,
              onPressed: _showQuickActions,
              child: const Icon(Icons.grid_view, color: AppColors.textPrimary),
            ),
            SizedBox(
              width: 64,
              height: 64,
              child: FloatingActionButton(
                heroTag: 'add_expense_fab',
                backgroundColor: AppColors.surfaceObsidian,
                onPressed: _showAddExpenseModal,
                child: const Icon(Icons.add, color: AppColors.textPrimary, size: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return transactionsAsync.when(
      data: (transactions) {
        if (transactions.isEmpty) return const SizedBox(height: AppSpacing.xxl);

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
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (context, index) {
              final cat = sortedCategories[index];
              final color = categoryColors[cat.key] ?? Colors.grey;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceObsidian,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '${cat.key} ${formatter.format(cat.value)}',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                ),
              );
            },
          ),
        );
      },
      loading: () => const SizedBox(height: 40, child: Center(child: CircularProgressIndicator())),
      error: (_, __) => const SizedBox(height: AppSpacing.xxl),
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
                color: isActive ? AppColors.surfaceObsidian : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Text(
                period,
                style: TextStyle(
                  color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
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
          return Padding(
            padding: const EdgeInsets.all(48.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.receipt_long, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.5)),
                  const SizedBox(height: AppSpacing.md),
                  const Text(
                    'No expenses found',
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  const Text(
                    'Try changing the period or add a new expense.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                  ),
                ],
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
                context.pushNamed('expense-detail', extra: {
                  'title': t.transaction.note ?? t.category.name,
                  'amount': formatter.format(t.transaction.amount),
                  'category': t.category.name,
                  'date': dateStr,
                  'onDelete': () async {
                    final dao = ref.read(expenseDaoProvider);
                    await dao.deleteTransaction(t.transaction);
                    if (context.mounted) context.pop();
                  },
                });
              },
              title: Text(t.transaction.note ?? t.category.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
              subtitle: Text('${t.category.name} • $dateStr', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatter.format(t.transaction.amount),
                    style: TextStyle(color: amountColor, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text('Error: $e', style: const TextStyle(color: AppColors.semanticUrgent))),
    );
  }
}
