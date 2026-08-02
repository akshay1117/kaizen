import 'package:flutter/material.dart';
import 'balances_bottom_sheet.dart';
import 'categories_bottom_sheet.dart';
import 'subscriptions_bottom_sheet.dart';
import 'installments_bottom_sheet.dart';
import 'expense_filter_bottom_sheet.dart';
import 'tracker_settings_modal.dart';

import 'dart:ui';

class QuickActionsBottomSheet extends StatelessWidget {
  const QuickActionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E).withValues(alpha: 0.7),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3C),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          _buildActionItem(context, Icons.edit, 'Edit Tracker', () {
            final nav = Navigator.of(context);
            nav.pop();
            showModalBottomSheet(
              context: nav.context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const TrackerSettingsModal(),
              ),
            );
          }),
          _buildActionItem(context, Icons.filter_list, 'Filter', () {
            final nav = Navigator.of(context);
            nav.pop();
            showModalBottomSheet(
              context: nav.context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => const ExpenseFilterBottomSheet(),
            );
          }),
          _buildActionItem(context, Icons.pie_chart, 'Balances', () {
            final nav = Navigator.of(context);
            nav.pop();
            showModalBottomSheet(
              context: nav.context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const ExpenseBalancesBottomSheet(),
              ),
            );
          }),
          _buildActionItem(context, Icons.credit_card, 'Installments', () {
            final nav = Navigator.of(context);
            nav.pop();
            showModalBottomSheet(
              context: nav.context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const InstallmentsBottomSheet(),
              ),
            );
          }),
          _buildActionItem(context, Icons.autorenew, 'Subscriptions', () {
            final nav = Navigator.of(context);
            nav.pop();
            showModalBottomSheet(
              context: nav.context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const SubscriptionsBottomSheet(),
              ),
            );
          }),
          _buildActionItem(context, Icons.label, 'Custom Categories', () {
            final nav = Navigator.of(context);
            nav.pop();
            showModalBottomSheet(
              context: nav.context,
              backgroundColor: Colors.transparent,
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: const ExpenseCategoriesBottomSheet(),
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title, [VoidCallback? onTap]) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else {
          Navigator.pop(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.3), size: 20),
          ],
        ),
      ),
    );
  }
}
