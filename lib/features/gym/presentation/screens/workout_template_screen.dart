import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/screens/exercise_selection_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/exercise_detail_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';

class WorkoutTemplateScreen extends ConsumerWidget {
  const WorkoutTemplateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(exercisesStreamProvider);

    return Scaffold(
      backgroundColor: GymTheme.background,
      appBar: AppBar(
        backgroundColor: GymTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: GymTheme.primaryAccent, size: 32.sp),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Exercises',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            color: GymTheme.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: GymTheme.primaryAccent, width: 1.5),
              ),
              child: Icon(LucideIcons.moreHorizontal, color: GymTheme.primaryAccent, size: 16.sp),
            ),
            onPressed: () {},
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: Stack(
        children: [
          exercisesAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return const Center(child: Text('No exercises found', style: TextStyle(color: GymTheme.textSecondary)));
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h).copyWith(bottom: 100.h),
                itemCount: exercises.length,
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemBuilder: (context, index) {
                  final ex = exercises[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ExerciseDetailScreen(exerciseId: ex.id, exerciseName: ex.name),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        decoration: BoxDecoration(
                          color: GymTheme.cardSurface2,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ex.name,
                                    style: TextStyle(
                                      color: GymTheme.textPrimary,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (ex.primaryMuscles.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      ex.primaryMuscles.first.name,
                                      style: TextStyle(
                                        color: GymTheme.textSecondary,
                                        fontSize: 13.sp,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            Icon(LucideIcons.chevronRight, color: GymTheme.textSecondary, size: 20.sp),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
          ),
          
          // Floating Add Exercises Button
          Positioned(
            left: 16.w,
            right: 16.w,
            bottom: 24.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GymTheme.primaryAccent,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 4,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExerciseSelectionScreen()),
                );
              },
              child: Text(
                '+ Add Exercises',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
