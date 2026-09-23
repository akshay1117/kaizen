import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/dashboard/presentation/providers/tracker_providers.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/core/theme/app_colors.dart';

import 'package:kaizen/core/constants/app_strings.dart';
import 'package:kaizen/core/constants/app_constants.dart';

class CaloriesDetailModal extends ConsumerWidget {
  const CaloriesDetailModal({super.key});
  static void show(BuildContext context) {
    if (MediaQuery.of(context).size.width > 600) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: AppColors.surfaceElevatedMid,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: const CaloriesDetailModal(),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const CaloriesDetailModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final calorieEntriesAsync = ref.watch(calorieEntriesProvider);
    final dailyTotal = ref.watch(caloriesProvider);
    const dailyGoal = AppConstants.defaultDailyCalorieGoal;

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
                  AppStrings.nutrition,
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
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(LucideIcons.calendar, color: Color(0xFF8B5CF6), size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
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
                      const Color(0xFF10B981).withValues(alpha: 0.15),
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
                  color: const Color(0xFF10B981),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  const Icon(LucideIcons.flame, color: Color(0xFF10B981), size: 32),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '$dailyTotal',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -1,
                    ),
                  ),
                  const Text(
                    '/ ${AppConstants.defaultDailyCalorieGoal} kcal',
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
          const SizedBox(height: AppSpacing.xxl),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => _showAddEntryDialog(context, ref),
                icon: const Icon(LucideIcons.plus, color: Colors.white),
                label: const Text(
                  AppStrings.addMeal,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
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
                    AppStrings.mealsToday,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Color(0xFF94A3B8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: calorieEntriesAsync.when(
                      data: (entries) {
                        if (entries.isEmpty) {
                          return const Center(
                            child: Text(
                              AppStrings.noMealsLogged,
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
                                child: const Icon(LucideIcons.utensils, color: Color(0xFF10B981), size: 20),
                              ),
                              title: Text(
                                entry.mealType.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                entry.name ?? '',
                                style: const TextStyle(color: Color(0xFF64748B)),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${entry.calories} kcal',
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  IconButton(
                                    icon: const Icon(LucideIcons.trash2, color: Color(0xFFF43F5E), size: 18),
                                    onPressed: () {
                                      ref.read(healthRepositoryProvider).deleteCalorieEntry(entry.id);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF10B981))),
                      error: (err, stack) => const Center(child: Text(AppStrings.errorLoadingEntries)),
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
    final caloriesController = TextEditingController();
    final nameController = TextEditingController();
    final date = ref.read(selectedDateProvider);
    String mealType = AppStrings.breakfast;
    const mealOptions = [AppStrings.breakfast, AppStrings.lunch, AppStrings.dinner, AppStrings.snack];

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1D2B),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: const BorderSide(color: Color(0xFF25293C)),
              ),
              title: const Text(AppStrings.addMeal, style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: mealType,
                    dropdownColor: const Color(0xFF1A1D2B),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF0D0E15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF25293C)),
                      ),
                    ),
                    items: mealOptions.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => mealType = val);
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm * 1.5),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: AppStrings.mealNameOptional,
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFF0D0E15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF25293C)),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm * 1.5),
                  TextField(
                    controller: caloriesController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: AppStrings.caloriesKcal,
                      hintStyle: const TextStyle(color: Color(0xFF64748B)),
                      filled: true,
                      fillColor: const Color(0xFF0D0E15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF25293C)),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(AppStrings.cancel, style: TextStyle(color: Color(0xFF94A3B8))),
                ),
                ElevatedButton(
                  onPressed: () {
                    final cal = int.tryParse(caloriesController.text);
                    if (cal != null) {
                      ref.read(healthRepositoryProvider).addCalorieEntry(mealType, nameController.text, cal, date);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(AppStrings.save, style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          }
        );
      },
    );
  }
}
