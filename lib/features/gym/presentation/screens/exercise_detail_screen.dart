import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/widgets/exercise_set_history_view.dart';
import 'package:kaizen/features/gym/presentation/widgets/exercise_analysis_view.dart';
import 'package:kaizen/features/gym/presentation/widgets/exercise_1rm_analysis_view.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;
  final String exerciseName;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  int _selectedIndex = 0; // 0: Sets, 1: Analyze, 2: 1RM

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.surfacePitchBlack, // Dark background
        body: SafeArea(
          child: Column(
            children: [
              // Custom App Bar (moved beneath SafeArea)
              Padding(
                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
                    Padding(
                      padding: EdgeInsets.only(left: 16.w),
                      child: CircleAvatar(
                        backgroundColor: GymTheme.cardSurface2,
                        child: IconButton(
                          icon: Icon(LucideIcons.chevronLeft,
                              color: GymTheme.textSecondary, size: 24.sp),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    // Title
                    Expanded(
                      child: Text(
                        widget.exerciseName,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                          color: GymTheme.textPrimary,
                        ),
                      ),
                    ),
                    // Actions
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          backgroundColor: GymTheme.cardSurface2,
                          child: IconButton(
                            icon: Icon(LucideIcons.menu,
                                color: GymTheme.textSecondary, size: 20.sp),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 8.w),
                        CircleAvatar(
                          backgroundColor: GymTheme.cardSurface2,
                          child: IconButton(
                            icon: Icon(LucideIcons.moreHorizontal,
                                color: GymTheme.textSecondary, size: 20.sp),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(width: 16.w),
                      ],
                    ),
                  ],
                ),
              ),
              // Segmented Control
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: GymTheme.cardBackground,
                    borderRadius: BorderRadius.circular(32.r),
                    border: Border.all(color: GymTheme.cardSurface2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTabButton(
                          index: 0,
                          label: 'Sets',
                          icon: LucideIcons.list,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          index: 1,
                          label: 'Analyze',
                          icon: LucideIcons.lineChart,
                        ),
                      ),
                      Expanded(
                        child: _buildTabButton(
                          index: 2,
                          label: '1RM',
                          icon: LucideIcons.timer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab Content
              Expanded(
                child: IndexedStack(
                  index: _selectedIndex,
                  children: [
                    ExerciseSetHistoryView(exerciseId: widget.exerciseId),
                    ExerciseAnalysisView(exerciseId: widget.exerciseId),
                    ExerciseOneRmAnalysisView(exerciseId: widget.exerciseId),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildTabButton(
      {required int index, required String label, required IconData icon}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        height: 40.h,
        decoration: BoxDecoration(
          color: isSelected ? GymTheme.cardSurface2 : Colors.transparent,
          borderRadius: BorderRadius.circular(32.r), // Pill shape
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: isSelected ? GymTheme.textPrimary : GymTheme.textSecondary,
            ),
            SizedBox(width: 8.w),
            Text(
              label,
              style: TextStyle(
                color:
                    isSelected ? GymTheme.textPrimary : GymTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
