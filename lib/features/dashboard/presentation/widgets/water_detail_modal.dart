import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/dashboard/presentation/providers/tracker_providers.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/core/theme/app_colors.dart';

class WaterDetailModal extends ConsumerWidget {
  const WaterDetailModal({super.key});

  static void show(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: AppColors.surfaceElevatedMid.withValues(alpha: 0.5),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const WaterDetailModal(),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const WaterDetailModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final waterEntriesAsync = ref.watch(waterEntriesProvider);
    final dailyTotal = ref.watch(waterIntakeProvider);
    const dailyGoal = 3.0;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0E15),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        border: Border(
          top: BorderSide(color: Color(0xFF25293C), width: 1),
          left: BorderSide(color: Color(0xFF25293C), width: 1),
          right: BorderSide(color: Color(0xFF25293C), width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF333852),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'WATER INTAKE',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFF94A3B8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (date != null) {
                      ref.read(selectedDateProvider.notifier).state = date;
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF141622),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF25293C)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          DateFormat('MMM d, yyyy').format(selectedDate),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        const SizedBox(width: 4),
                        const Icon(LucideIcons.calendar, color: Color(0xFF8B5CF6), size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF38BDF8).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: (dailyTotal / dailyGoal).clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: const Color(0xFF1A1D2B),
                  color: const Color(0xFF38BDF8),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  const Icon(LucideIcons.droplets, color: Color(0xFF38BDF8), size: 32),
                  const SizedBox(height: 8),
                  Text(
                    dailyTotal.toStringAsFixed(1),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text(
                    '/ 3.0 L',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showAddEntryDialog(context, ref),
                icon: const Icon(LucideIcons.plus, color: Colors.white),
                label: const Text(
                  'Add Water',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF141622),
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                border: Border(
                  top: BorderSide(color: Color(0xFF25293C), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "TODAY'S LOG",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: waterEntriesAsync.when(
                      data: (entries) {
                        if (entries.isEmpty) {
                          return const Center(
                            child: Text(
                              'No water logged yet.',
                              style: TextStyle(color: Color(0xFF64748B)),
                            ),
                          );
                        }
                        return ListView.separated(
                          itemCount: entries.length,
                          separatorBuilder: (context, index) => const Divider(color: Color(0xFF25293C)),
                          itemBuilder: (context, index) {
                            final entry = entries[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1A1D2B),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: const Color(0xFF25293C)),
                                ),
                                child: const Icon(LucideIcons.glassWater, color: Color(0xFF38BDF8), size: 20),
                              ),
                              title: Text(
                                '${entry.amount.toStringAsFixed(2)} L',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat('h:mm a').format(entry.createdAt),
                                style: const TextStyle(color: Color(0xFF64748B)),
                              ),
                              trailing: IconButton(
                                icon: const Icon(LucideIcons.trash2, color: Color(0xFFF43F5E), size: 18),
                                onPressed: () {
                                  ref.read(healthRepositoryProvider).deleteWaterEntry(entry.id);
                                },
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF38BDF8))),
                      error: (err, stack) => const Center(child: Text('Error loading entries')),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context, WidgetRef ref) {
    final amountController = TextEditingController(text: "0.25");
    final date = ref.read(selectedDateProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1D2B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF25293C)),
        ),
        title: const Text('Add Water (Liters)', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0D0E15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF25293C)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF38BDF8)),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(amountController.text);
              if (val != null) {
                ref.read(healthRepositoryProvider).addWater(val, date);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF38BDF8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
