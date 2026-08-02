import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_dao.dart';

class ExpenseDashboardScreen extends ConsumerWidget {
  const ExpenseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceDataAsync = ref.watch(balanceDataProvider);
    final transactionsAsync = ref.watch(transactionsForMonthProvider);
    final currencyFmt = ref.watch(currencyFormatterProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: GlassAppBar(
        backgroundColor: Colors.black,
        title: const Text('Overview', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: GlassScaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildBalanceCard(balanceDataAsync, currencyFmt),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {},
                          child: const Text('See All', style: TextStyle(color: Color(0xFF2F86FF))),
                        ),
                      ],
                    ),
                  ),
                ),
                transactionsAsync.when(
                  data: (transactions) {
                    if (transactions.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text('No transactions this month.', style: TextStyle(color: Colors.grey)),
                          ),
                        ),
                      );
                    }
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final txDetail = transactions[index];
                          return _buildTransactionRow(txDetail, currencyFmt);
                        },
                        childCount: transactions.length,
                      ),
                    );
                  },
                  loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
                  error: (e, st) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: FloatingActionButton(
                heroTag: 'expense_add_fab',
                backgroundColor: const Color(0xFF2F86FF),
                onPressed: () {
                  context.push('/expenses/add');
                },
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(AsyncValue<BalanceData> balanceDataAsync, NumberFormat currencyFmt) {
    return GlassCard(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A).withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(20),
        ),
        child: balanceDataAsync.when(
          data: (data) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Total Balance', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 8),
              Text(
                currencyFmt.format(data.totalBalance),
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildIncomeExpensePill(true, data.income, currencyFmt)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildIncomeExpensePill(false, data.expense, currencyFmt)),
                ],
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Text('Error: $e'),
        ),
      ),
    );
  }

  Widget _buildIncomeExpensePill(bool isIncome, double amount, NumberFormat currencyFmt) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isIncome ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? Colors.green : Colors.red,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isIncome ? 'Income' : 'Expense', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                Text(
                  currencyFmt.format(amount),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionRow(TransactionWithDetails txDetail, NumberFormat currencyFmt) {
    final t = txDetail.transaction;
    final c = txDetail.category;
    
    // Parse colorHex or fallback
    Color categoryColor = Colors.blue;
    try {
      if (c.colorHex.length == 6) {
        categoryColor = Color(int.parse('0xFF${c.colorHex}'));
      }
    } catch (_) {}

    IconData getIcon(String name) {
      switch (name) {
        case 'utensils': return Icons.restaurant;
        case 'car': return Icons.directions_car;
        case 'shopping-bag': return Icons.shopping_bag;
        case 'briefcase': return Icons.work;
        default: return Icons.category;
      }
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(getIcon(c.icon), color: categoryColor),
      ),
      title: Text(c.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      subtitle: Text(t.note?.isNotEmpty == true ? t.note! : DateFormat('MMM d, yyyy').format(t.date), style: const TextStyle(color: Colors.grey, fontSize: 12)),
      trailing: Text(
        '${t.isIncome ? '+' : '-'}${currencyFmt.format(t.amount)}',
        style: TextStyle(
          color: t.isIncome ? Colors.green : Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
