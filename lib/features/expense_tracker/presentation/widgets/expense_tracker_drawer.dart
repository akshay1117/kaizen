import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';
import '../screens/analytics_screen.dart';
import 'balances_bottom_sheet.dart';
import 'subscriptions_bottom_sheet.dart';
import 'installments_bottom_sheet.dart';
import 'tracker_settings_modal.dart';
import '../../application/export_service.dart';

class ExpenseTrackerDrawer extends ConsumerWidget {
  const ExpenseTrackerDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrackerAsync = ref.watch(currentTrackerProvider);
    
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A84FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: currentTrackerAsync.when(
                      data: (tracker) => Text(
                        tracker?.name ?? 'No Tracker',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      loading: () => const Text('Loading...', style: TextStyle(color: Colors.white)),
                      error: (_, __) => const Text('Error', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Color(0xFF0A84FF)),
                ],
              ),
            ),
            const Divider(color: Color(0xFF3A3A3C), height: 1),
            
            // Navigation Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  _buildDrawerItem(context, Icons.account_balance_wallet, 'Balances (Shared)', () {
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
                  _buildDrawerItem(context, Icons.add_box, 'New Tracker', () {
                    final nav = Navigator.of(context);
                    nav.pop(); // Close Drawer
                    showModalBottomSheet(
                      context: nav.context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height * 0.9,
                        child: const TrackerSettingsModal(),
                      ),
                    );
                  }),
                  _buildDrawerItem(context, Icons.person_add, 'Join Tracker'),
                  _buildDrawerItem(context, Icons.bar_chart, 'Analytics', () {
                    final nav = Navigator.of(context);
                    nav.pop();
                    nav.push(
                      MaterialPageRoute(builder: (context) => const ExpenseAnalyticsScreen()),
                    );
                  }),
                  _buildDrawerItem(context, Icons.autorenew, 'Subscriptions', () {
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
                  _buildDrawerItem(context, Icons.credit_score, 'Installments', () {
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
                  _buildDrawerItem(context, Icons.sync, 'Currency Converter', null, true),
                  _buildDrawerItem(context, Icons.file_download, 'Export', () async {
                    final dao = ref.read(expenseDaoProvider);
                    final transactions = await dao.getAllTransactionsWithDetails();
                    await ExpenseExportService.exportToCsv(transactions);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  }, true),
                ],
              ),
            ),
            
            const Divider(color: Color(0xFF3A3A3C), height: 1),
            
            // Footer Items
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  _buildDrawerItem(context, Icons.person, 'Profile'),
                  _buildDrawerItem(context, Icons.settings, 'Settings'),
                  _buildDrawerItem(context, Icons.logout, 'Log out', null, false, const Color(0xFFFF3B30)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, [VoidCallback? onTap, bool isPro = false, Color textColor = Colors.white]) {
    return ListTile(
      leading: Icon(icon, color: textColor == Colors.white ? const Color(0xFF8E8E93) : textColor),
      title: Row(
        children: [
          Text(
            title,
            style: TextStyle(color: textColor, fontSize: 16),
          ),
          if (isPro) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF3A3A3C),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ]
        ],
      ),
      onTap: onTap ?? () {},
    );
  }
}
