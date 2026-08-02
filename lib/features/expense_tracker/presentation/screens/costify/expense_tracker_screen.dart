import 'package:flutter/material.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/add_expense_modal.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/quick_actions_sheet.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/expense_detail_view.dart';
import 'package:kaizen/features/expense_tracker/presentation/screens/costify/tracker_drawer.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/donut_chart_widget.dart';

class ExpenseTrackerScreen extends StatefulWidget {
  const ExpenseTrackerScreen({super.key});

  @override
  State<ExpenseTrackerScreen> createState() => _ExpenseTrackerScreenState();
}

class _ExpenseTrackerScreenState extends State<ExpenseTrackerScreen> {
  String _selectedPeriod = '1Y';
  final List<String> _periods = ['24H', '7D', '1M', '3M', '1Y', 'Custom'];
  
  final List<Map<String, dynamic>> _expenses = [
    {'icon': Icons.fastfood, 'title': 'Mango juice', 'category': 'Personal', 'date': 'March 18, 2026', 'amount': '-₹30.00'},
    {'icon': Icons.restaurant, 'title': 'Lunch', 'category': 'Work', 'date': 'March 17, 2026', 'amount': '-₹250.00'},
    {'icon': Icons.directions_car, 'title': 'Uber', 'category': 'Transport', 'date': 'March 16, 2026', 'amount': '-₹120.00'},
  ];

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
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      drawer: const TrackerDrawer(),
      body: Stack(
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
                        _buildCategoryChips(),
                        const SizedBox(height: 24),
                        _buildTimePeriodSelector(),
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
    final categories = [
      {'name': '🍟 Canteen', 'amount': '₹1,088.00', 'color': 0xFFFF9500},
      {'name': '🛒 Groceries', 'amount': '₹450.00', 'color': 0xFF34C759},
      {'name': '🚕 Transport', 'amount': '₹300.50', 'color': 0xFF0A84FF},
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final color = Color(cat['color'] as int);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.5)),
            ),
            child: Text(
              '${cat['name']} ${cat['amount']}',
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimePeriodSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _periods.map((period) {
          final isActive = _selectedPeriod == period;
          return GestureDetector(
            onTap: () => setState(() => _selectedPeriod = period),
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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final ex = _expenses[index];
        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ExpenseDetailView(
                title: ex['title'] as String,
                amount: ex['amount'] as String,
                category: ex['category'] as String,
                date: ex['date'] as String,
                onDelete: () {
                  setState(() {
                    _expenses.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              )),
            );
          },
          leading: CircleAvatar(
            backgroundColor: const Color(0xFF1C1C1E),
            child: Icon(ex['icon'] as IconData, color: Colors.white, size: 20),
          ),
          title: Text(ex['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          subtitle: Text('${ex['category']} • ${ex['date']}', style: const TextStyle(color: Color(0xFF8E8E93), fontSize: 12)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ex['amount'] as String,
                style: const TextStyle(color: Color(0xFFFF3B30), fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right, color: Color(0xFF8E8E93)),
            ],
          ),
        );
      },
    );
  }
}
