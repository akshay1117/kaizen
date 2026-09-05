import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';

class ExpenseFilterBottomSheet extends ConsumerStatefulWidget {
  const ExpenseFilterBottomSheet({super.key});

  @override
  ConsumerState<ExpenseFilterBottomSheet> createState() => _ExpenseFilterBottomSheetState();
}

class _ExpenseFilterBottomSheetState extends ConsumerState<ExpenseFilterBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(expenseFilterProvider);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF161618),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevatedHigh,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: const Text('Done', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Sort By Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceObsidian,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: ListTile(
              title: const Text('Sort by', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filterState.sortBy, style: const TextStyle(color: AppColors.textSecondary, fontSize: 16)),
                  const SizedBox(width: 4),
                  const Icon(CupertinoIcons.chevron_up_chevron_down, color: AppColors.textSecondary, size: 14),
                ],
              ),
              onTap: () => _showSortByOptions(filterState),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Toggles Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceObsidian,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.credit_card, color: AppColors.textPrimary),
                  title: const Text('Installments only', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                  trailing: CupertinoSwitch(
                    value: filterState.installmentsOnly,
                    onChanged: (val) {
                      ref.read(expenseFilterProvider.notifier).state = filterState.copyWith(installmentsOnly: val);
                    },
                    activeTrackColor: AppColors.textPrimary,
                    inactiveTrackColor: const Color(0xFF3A3A3C),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 56),
                  child: Divider(color: AppColors.surfaceElevatedHigh, height: 1),
                ),
                ListTile(
                  leading: const Icon(Icons.autorenew, color: AppColors.textPrimary),
                  title: const Text('Subscriptions only', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                  trailing: CupertinoSwitch(
                    value: filterState.subscriptionsOnly,
                    onChanged: (val) {
                      ref.read(expenseFilterProvider.notifier).state = filterState.copyWith(subscriptionsOnly: val);
                    },
                    activeTrackColor: AppColors.textPrimary,
                    inactiveTrackColor: const Color(0xFF3A3A3C),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Members Card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceObsidian,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('All members', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                  trailing: const Icon(Icons.check, color: AppColors.textPrimary),
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Divider(color: AppColors.surfaceElevatedHigh, height: 1),
                ),
                ListTile(
                  leading: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3A3A3C),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: const Text('A', style: TextStyle(color: AppColors.accentViolet, fontWeight: FontWeight.bold)),
                  ),
                  title: const Text('Akshaykrishnantv', style: TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  void _showSortByOptions(ExpenseFilterOptions filterState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceObsidian,
          borderRadius: BorderRadius.circular(AppRadii.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('Date', filterState.sortBy),
            const Divider(color: AppColors.surfaceElevatedHigh, height: 1),
            _buildSortOption('Name', filterState.sortBy),
            const Divider(color: AppColors.surfaceElevatedHigh, height: 1),
            _buildSortOption('Amount', filterState.sortBy),
            const Divider(color: AppColors.surfaceElevatedHigh, height: 1),
            _buildSortOption('Category', filterState.sortBy),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String name, String currentSort) {
    return ListTile(
      title: Text(name, style: const TextStyle(color: AppColors.textPrimary)),
      trailing: currentSort == name ? const Icon(Icons.check, color: AppColors.textPrimary) : null,
      onTap: () {
        final currentState = ref.read(expenseFilterProvider);
        ref.read(expenseFilterProvider.notifier).state = currentState.copyWith(sortBy: name);
        Navigator.pop(context);
      },
    );
  }
}
