import 'package:flutter/material.dart';
import 'balances_modal.dart';
import 'subscriptions_modal.dart';
import 'custom_categories_modal.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/tracker_settings_modal.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/expense_filter_bottom_sheet.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/installments_bottom_sheet.dart';

class QuickActionsSheet extends StatelessWidget {
  const QuickActionsSheet({super.key});

  void _showModal(BuildContext context, Widget modal) {
    Navigator.pop(context); // Close the quick actions sheet first
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => modal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionItem(Icons.edit, 'Edit Tracker', () => _showModal(context, const TrackerSettingsModal())),
          _buildActionItem(Icons.filter_list, 'Filter', () => _showModal(context, const ExpenseFilterBottomSheet())),
          _buildActionItem(Icons.pie_chart, 'Balances', () => _showModal(context, const BalancesModal())),
          _buildActionItem(Icons.credit_card, 'Installments', () => _showModal(context, const InstallmentsBottomSheet())),
          _buildActionItem(Icons.autorenew, 'Subscriptions', () => _showModal(context, const SubscriptionsModal())),
          _buildActionItem(Icons.local_offer, 'Custom Categories', () => _showModal(context, const CustomCategoriesModal())),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
