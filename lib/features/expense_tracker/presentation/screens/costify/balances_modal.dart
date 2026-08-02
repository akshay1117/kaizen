import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';

class BalancesModal extends ConsumerWidget {
  const BalancesModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return transactionsAsync.when(
      data: (transactions) {
        double totalSpent = 0;
        int expenseCount = 0;
        final categoryTotals = <String, double>{};
        
        for (final t in transactions) {
          if (!t.transaction.isIncome) {
            totalSpent += t.transaction.amount;
            expenseCount++;
            final catName = t.category.name;
            categoryTotals[catName] = (categoryTotals[catName] ?? 0) + t.transaction.amount;
          }
        }
        
        const memberCount = 1; // Currently hardcoded to 1 member in UI based on reference
        final avgPerPerson = memberCount > 0 ? totalSpent / memberCount : 0.0;

        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF161618),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3A3A3C),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Balances',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard('Total spent', formatter.format(totalSpent), Icons.credit_card, const Color(0xFF0A84FF)),
                  _buildStatCard('Avg / person', formatter.format(avgPerPerson), Icons.people, const Color(0xFF34C759)),
                  _buildStatCard('Members', memberCount.toString(), Icons.group, const Color(0xFFFF2D55)),
                  _buildStatCard('Expenses', expenseCount.toString(), Icons.receipt_long, const Color(0xFFFF9500)),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Members',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildMemberExpandableCard('Akshaykrishnantv', totalSpent, categoryTotals, formatter),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xFF161618),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xFF161618),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberExpandableCard(String name, double total, Map<String, double> categoryTotals, var formatter) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF3A3A3C),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.person, color: Colors.blueAccent),
          ),
          title: Row(
            children: [
              Text(
                name,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text(
                'You',
                style: TextStyle(color: Colors.blueAccent, fontSize: 12),
              ),
            ],
          ),
          subtitle: const Text('Real cost in this tracker', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
          trailing: Text(
            formatter.format(total),
            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          children: [
            const Divider(color: Color(0xFF2C2C2E)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Details', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
                  const SizedBox(height: 8),
                  ...categoryTotals.entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key, style: const TextStyle(color: Colors.white)),
                        Text(formatter.format(e.value), style: const TextStyle(color: Color(0xFF8E8E93))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
