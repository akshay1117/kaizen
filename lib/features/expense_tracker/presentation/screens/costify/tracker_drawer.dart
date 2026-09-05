import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'analytics_screen.dart';
import 'new_tracker_modal.dart';

class TrackerDrawer extends ConsumerWidget {
  const TrackerDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trackersAsync = ref.watch(trackersProvider);
    final selectedTrackerId = ref.watch(selectedTrackerIdProvider);

    return Drawer(
      backgroundColor: AppColors.surfaceObsidian,
      child: SafeArea(
        child: Column(
          children: [
            // Trackers List
            trackersAsync.when(
              data: (trackers) {
                if (trackers.isEmpty) {
                  return const SizedBox.shrink(); // Hide if no trackers
                }
                return Column(
                  children: trackers.map((tracker) {
                    final isSelected = selectedTrackerId == tracker.id || (selectedTrackerId == null && trackers.first.id == tracker.id);
                    return InkWell(
                      onTap: () {
                        ref.read(selectedTrackerIdProvider.notifier).state = tracker.id;
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceElevatedHigh,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.wallet, color: AppColors.textPrimary, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                tracker.name,
                                style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 20),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppColors.textTertiary, size: 20),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () async {
                                final dao = ref.read(expenseDaoProvider);
                                await dao.deleteTracker(tracker);
                                if (isSelected) {
                                  ref.read(selectedTrackerIdProvider.notifier).state = null;
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => const SizedBox.shrink(),
            ),
            
            const Divider(color: AppColors.surfaceElevatedHigh, thickness: 1),
            
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
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, {bool isPro = false, Color color = AppColors.textPrimary, VoidCallback? onTap}) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      leading: Icon(icon, color: color, size: 20),
      title: Row(
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 14)),
          if (isPro) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentViolet.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('PRO', style: TextStyle(color: AppColors.accentViolet, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      onTap: onTap ?? () {},
    );
  }
}

