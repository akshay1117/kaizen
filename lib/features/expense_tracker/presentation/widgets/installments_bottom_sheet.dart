import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';
import 'add_installment_modal.dart';

class InstallmentsBottomSheet extends ConsumerWidget {
  const InstallmentsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installmentsAsync = ref.watch(installmentsProvider);
    
    // Calculate totals
    int activePlans = 0;
    double openAmount = 0.0;
    double dueNextMonth = 0.0;
    double paidThisMonth = 0.0; // Needs tracking of payments which we might not have yet

    if (installmentsAsync.value != null) {
      for (var inst in installmentsAsync.value!) {
        activePlans++;
        openAmount += (inst.totalAmount - inst.installmentAmount); // Assuming 1 installment paid, just mockup logic
        dueNextMonth += inst.installmentAmount;
      }
    }

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
                  'Installments',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.surfaceElevatedHigh,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: AppColors.textPrimary, size: 20),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: const AddInstallmentModal(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: _buildGridCard(Icons.list_alt, AppColors.textSecondary, '$activePlans', 'Active plans')),
                const SizedBox(width: 12),
                Expanded(child: _buildGridCard(Icons.content_paste, AppColors.textSecondary, '₹${openAmount.toStringAsFixed(2)}', 'Open amount')),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(child: _buildGridCard(Icons.edit_calendar, AppColors.textSecondary, '₹${dueNextMonth.toStringAsFixed(2)}', 'Due next month')),
                const SizedBox(width: 12),
                Expanded(child: _buildGridCard(Icons.check_circle_outline, AppColors.textSecondary, '₹${paidThisMonth.toStringAsFixed(2)}', 'Paid this month')),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // List or Empty state
          Expanded(
            child: installmentsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF3A3A3C))),
              error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.semanticUrgent))),
              data: (installments) {
                if (installments.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.list_alt, color: AppColors.textSecondary, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'No installment plans yet.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: installments.length,
                  separatorBuilder: (context, index) => const Divider(color: AppColors.surfaceElevatedHigh, height: 1),
                  itemBuilder: (context, index) {
                    final inst = installments[index];
                    final progress = (inst.installmentAmount / inst.totalAmount).clamp(0.0, 1.0);
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      title: Text(
                        inst.name,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppColors.surfaceElevatedHigh,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentViolet),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('₹${inst.installmentAmount.toStringAsFixed(2)} / mo', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              Text('${(progress * 100).toInt()}% paid', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(IconData icon, Color iconColor, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16),
              const SizedBox(width: 8),
              Expanded(child: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
