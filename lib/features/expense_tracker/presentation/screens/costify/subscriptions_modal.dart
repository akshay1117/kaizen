import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/add_subscription_modal.dart';

class SubscriptionsModal extends ConsumerWidget {
  const SubscriptionsModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionsAsync = ref.watch(subscriptionsProvider);
    final formatter = ref.watch(currencyFormatterProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfacePitchBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Subscriptions',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.textPrimary),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => SizedBox(
                          height: MediaQuery.of(context).size.height * 0.9,
                          child: const AddSubscriptionModal(),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textTertiary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          subscriptionsAsync.when(
            data: (subscriptions) {
              int activeCount = subscriptions.length;
              double monthlyTotal = 0;
              double yearlyTotal = 0;

              for (final sub in subscriptions) {
                if (sub.interval == '1 Month') {
                  monthlyTotal += sub.amount;
                  yearlyTotal += sub.amount * 12;
                } else if (sub.interval == '1 Year') {
                  yearlyTotal += sub.amount;
                  monthlyTotal += sub.amount / 12;
                }
              }

              return Column(
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surfaceElevatedHigh, width: 8),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$activeCount',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Active',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Monthly total', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(formatter.format(monthlyTotal), style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('Yearly total', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(formatter.format(yearlyTotal), style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Active', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  if (subscriptions.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Text('No active subscriptions.', style: TextStyle(color: AppColors.textSecondary)),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: subscriptions.length,
                      itemBuilder: (context, index) {
                        final sub = subscriptions[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(sub.name, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          subtitle: Text(sub.interval, style: const TextStyle(color: AppColors.textSecondary)),
                          trailing: Text(formatter.format(sub.amount), style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                        );
                      },
                    ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.semanticUrgent))),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
