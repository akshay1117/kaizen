import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/domain/gym_use_cases.dart';

class ExerciseOneRmAnalysisView extends ConsumerWidget {
  final String exerciseId;
  const ExerciseOneRmAnalysisView({super.key, required this.exerciseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final setsAsync = ref.watch(allSetEntriesStreamProvider);
    
    return setsAsync.when(
      data: (allSets) {
        final exerciseSets = allSets.where((s) => s.exerciseId == exerciseId).toList();
        
        // Group sets by Day and compute max 1RM
        final grouped = <DateTime, double>{};
        for (var set in exerciseSets) {
          final day = DateTime(set.performedAt.year, set.performedAt.month, set.performedAt.day);
          final oneRm = GymUseCases.calculateOneRm(set.weightKg, set.reps, OneRmFormula.epley);
          if (oneRm > (grouped[day] ?? 0)) {
            grouped[day] = oneRm;
          }
        }

        final sortedKeys = grouped.keys.toList()..sort();
        final chartBars = sortedKeys.map((k) => grouped[k]!).toList();
        
        double maxOneRm = 100.0;
        if (chartBars.isNotEmpty) {
           maxOneRm = chartBars.reduce((a, b) => a > b ? a : b);
           if (maxOneRm == 0) maxOneRm = 100.0;
        }
        
        // Calculate stats
        double current1RM = chartBars.isNotEmpty ? chartBars.last : 0.0;
        double maxHistorical1RM = chartBars.isNotEmpty ? maxOneRm : 0.0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stat Tiles
          Row(
            children: [
              Expanded(child: _buildStatTile('${current1RM.toStringAsFixed(1)} kg', 'Current 1RM', isSelected: true)),
              SizedBox(width: 8.w),
              Expanded(child: _buildStatTile('${maxHistorical1RM.toStringAsFixed(1)} kg', 'All Time High', isSelected: false)),
            ],
          ),
          SizedBox(height: 32.h),

          // Chart Title
          Text(
            '1RM PROGRESSION',
            style: TextStyle(
              color: GymTheme.textSecondary,
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 16.h),

          // Custom Bar Chart
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Y-Axis Labels (we'll place them absolutely if we wanted to overlay, 
                // but let's just make the bars and have the labels on the right)
                Expanded(
                  child: Stack(
                    children: [
                      // Grid lines (horizontal)
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildGridLine(),
                          _buildGridLine(),
                          _buildGridLine(),
                          _buildGridLine(),
                        ],
                      ),
                      
                      // Bars
                      Positioned.fill(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: chartBars.map((val) {
                            final heightRatio = val / maxOneRm;
                            return LayoutBuilder(
                              builder: (context, constraints) {
                                return Container(
                                  width: 12.w,
                                  height: constraints.maxHeight * heightRatio,
                                  decoration: BoxDecoration(
                                    color: GymTheme.primaryAccent,
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(2.r)),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      
                      // X-Axis Labels (mocked positions)
                      Positioned(
                        bottom: 0, left: 10.w,
                        child: _buildXLabel('6'),
                      ),
                      Positioned(
                        bottom: 0, left: 60.w,
                        child: _buildXLabel('10'),
                      ),
                      Positioned(
                        bottom: 0, left: 130.w,
                        child: _buildXLabel('16'),
                      ),
                      Positioned(
                        bottom: 0, left: 200.w,
                        child: _buildXLabel('22'),
                      ),
                      Positioned(
                        bottom: 0, left: 260.w,
                        child: _buildXLabel('28'),
                      ),
                    ],
                  ),
                ),

                // Y-Axis Labels
                SizedBox(width: 8.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildYLabel(maxOneRm.toStringAsFixed(0)),
                    _buildYLabel((maxOneRm * 0.66).toStringAsFixed(0)),
                    _buildYLabel((maxOneRm * 0.33).toStringAsFixed(0)),
                    _buildYLabel('0'),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),

          // Segmented Control (M, 6M, Y)
          Container(
            height: 40.h,
            decoration: BoxDecoration(
              color: GymTheme.cardSurface2,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Expanded(child: _buildTimeFilter('M', isSelected: true)),
                Container(width: 1, height: 20.h, color: AppColors.borderSpecular),
                Expanded(child: _buildTimeFilter('6M', isSelected: false)),
                Container(width: 1, height: 20.h, color: AppColors.borderSpecular),
                Expanded(child: _buildTimeFilter('Y', isSelected: false)),
              ],
            ),
          ),
        ],
      ),
    );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: GymTheme.destructive))),
    );
  }

  Widget _buildGridLine() {
    return Divider(
      height: 1,
      color: AppColors.textPrimary.withValues(alpha: 0.1),
    );
  }

  Widget _buildYLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: GymTheme.textSecondary,
        fontSize: 12.sp,
      ),
    );
  }
  
  Widget _buildXLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: GymTheme.textSecondary,
          fontSize: 12.sp,
        ),
      ),
    );
  }

  Widget _buildTimeFilter(String text, {required bool isSelected}) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppColors.textPrimary.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? AppColors.textPrimary : GymTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 14.sp,
        ),
      ),
    );
  }

  Widget _buildStatTile(String value, String label, {required bool isSelected}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? GymTheme.primaryAccent : GymTheme.cardSurface2,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: isSelected ? AppColors.surfacePitchBlack : AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.surfacePitchBlack : GymTheme.textSecondary,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
