import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/gym/presentation/screens/add_set_bottom_sheet.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

class ExerciseSetHistoryView extends ConsumerWidget {
  final String exerciseId;
  const ExerciseSetHistoryView({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(allSetEntriesStreamProvider);

    return Stack(
      children: [
        setsAsync.when(
          data: (allSets) {
            final exerciseSets = allSets.where((s) => s.exerciseId == exerciseId).toList();
            if (exerciseSets.isEmpty) {
              return const Center(child: Text('No history yet.', style: TextStyle(color: GymTheme.textSecondary)));
            }

            // Sort all sets descending for day order processing
            exerciseSets.sort((a, b) => b.performedAt.compareTo(a.performedAt));
            final grouped = <String, List<SetEntry>>{};
            
            for (var set in exerciseSets) {
              final dateStr = _formatDateHeader(set.performedAt);
              grouped.putIfAbsent(dateStr, () => []).add(set);
            }

            // For each day, we actually want the sets in chronological order (ascending)
            for (var key in grouped.keys) {
              grouped[key]!.sort((a, b) => a.performedAt.compareTo(b.performedAt));
            }

            final keys = grouped.keys.toList();

            return ListView.builder(
              padding: EdgeInsets.only(bottom: 220.h), // Padding for FAB + Nav
              itemCount: keys.length,
              itemBuilder: (context, sectionIndex) {
                final dateStr = keys[sectionIndex];
                final daySets = grouped[dateStr]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (sectionIndex > 0) SizedBox(height: 24.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Row(
                        children: [
                          Text(
                            dateStr,
                            style: TextStyle(color: GymTheme.textSecondary, fontSize: 14.sp),
                          ),
                          SizedBox(width: 4.w),
                          Icon(LucideIcons.chevronRight, color: GymTheme.textSecondary, size: 16.sp),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: daySets.asMap().entries.map((entry) {
                          final index = entry.key;
                          final set = entry.value;
                          final isLast = index == daySets.length - 1;
                          return Container(
                            decoration: BoxDecoration(
                              border: isLast ? null : const Border(
                                bottom: BorderSide(color: AppColors.surfaceElevatedHigh, width: 1),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: _buildSetRow(
                              index + 1,
                              DateFormat('h:mm a').format(set.performedAt),
                              set.reps,
                              set.weightKg.toInt(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: GymTheme.destructive))),
        ),

        // FAB Area
        Positioned(
          bottom: 110.h,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Green Add Button
              GestureDetector(
                onTap: () {
                  AddSetBottomSheet.show(context, exerciseId);
                },
                child: Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF34C759),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.surfacePitchBlack.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(LucideIcons.plus, color: AppColors.textPrimary, size: 36.sp),
                ),
              ),
              SizedBox(width: 16.w),
              // Smaller dark button
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: GymTheme.cardSurface2,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.surfacePitchBlack.withValues(alpha: 0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Icon(LucideIcons.layers, color: GymTheme.textSecondary, size: 24.sp),
                ),
              ),
            ],
          ),
        ),

        // Mock Bottom Navigation Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 90.h,
            padding: EdgeInsets.only(bottom: 20.h),
            decoration: BoxDecoration(
              color: GymTheme.cardSurface2.withValues(alpha: 0.8), // Glassmorphic look
              borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildNavItem(LucideIcons.dumbbell, 'Sets', true),
                _buildNavItem(LucideIcons.clock, 'Sessions', false),
                _buildNavItem(LucideIcons.user, 'Body', false),
                _buildNavItem(LucideIcons.calendar, 'Today', false),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final difference = DateTime(now.year, now.month, now.day).difference(DateTime(date.year, date.month, date.day)).inDays;
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Yesterday';
    return DateFormat('EEE, d MMM yyyy').format(date);
  }

  Widget _buildSetRow(int index, String time, int reps, int weight) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 24.w,
                child: Text(
                  '$index',
                  style: TextStyle(color: GymTheme.textSecondary, fontSize: 14.sp),
                ),
              ),
              Text(
                time,
                style: TextStyle(color: GymTheme.textSecondary, fontSize: 14.sp),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                '$reps ',
                style: TextStyle(color: const Color(0xFF34C759), fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
              Text(
                'rep',
                style: TextStyle(color: const Color(0xFF34C759), fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(width: 48.w),
              Text(
                '$weight ',
                style: TextStyle(color: GymTheme.weightAccent, fontSize: 16.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                'kg',
                style: TextStyle(color: GymTheme.weightAccent, fontSize: 12.sp, fontWeight: FontWeight.w600),
              ),
              SizedBox(width: 8.w),
              Icon(LucideIcons.chevronRight, color: GymTheme.textSecondary, size: 16.sp),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? const Color(0xFF34C759) : GymTheme.textSecondary, size: 24.sp),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFF34C759) : GymTheme.textSecondary,
            fontSize: 10.sp,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
