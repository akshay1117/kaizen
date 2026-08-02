import 'package:flutter/material.dart';
import 'analytics_screen.dart';
import 'new_tracker_modal.dart';

class TrackerDrawer extends StatelessWidget {
  const TrackerDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2C2C2E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.wallet, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Food Bills',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.check_circle, color: Color(0xFF34C759)),
                ],
              ),
            ),
            const Divider(color: Color(0xFF2C2C2E), thickness: 1),
            
            // Main Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(context, Icons.account_balance_wallet, 'Accounts'),
                  _buildDrawerItem(
                    context, 
                    Icons.add_box, 
                    'New Tracker',
                    onTap: () {
                      final navContext = Navigator.of(context).context;
                      Navigator.pop(context); // Close drawer
                      showModalBottomSheet(
                        context: navContext,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (bottomSheetContext) => Padding(
                          padding: EdgeInsets.only(bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom),
                          child: const NewTrackerModal(),
                        ),
                      );
                    }
                  ),
                  _buildDrawerItem(context, Icons.group_add, 'Join Tracker'),
                  _buildDrawerItem(
                    context, 
                    Icons.bar_chart, 
                    'Analytics',
                    onTap: () {
                      final nav = Navigator.of(context);
                      nav.pop(); // Close drawer
                      nav.push(
                        MaterialPageRoute(builder: (context) => const AnalyticsScreen()),
                      );
                    }
                  ),
                  _buildDrawerItem(context, Icons.currency_exchange, 'Currency Converter', isPro: true),
                  _buildDrawerItem(context, Icons.download, 'Export', isPro: true),
                ],
              ),
            ),
            
            const Divider(color: Color(0xFF2C2C2E), thickness: 1),
            
            // Footer Links
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  _buildDrawerItem(context, Icons.person, 'Profile'),
                  _buildDrawerItem(context, Icons.settings, 'Settings'),
                  _buildDrawerItem(context, Icons.logout, 'Log out', color: const Color(0xFFFF3B30)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, {bool isPro = false, Color color = Colors.white, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Row(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 16)),
          if (isPro) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF0A84FF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('PRO', style: TextStyle(color: Color(0xFF0A84FF), fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      onTap: onTap ?? () {},
    );
  }
}

