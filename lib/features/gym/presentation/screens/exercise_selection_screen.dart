import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart';
import 'package:kaizen/features/gym/presentation/providers/active_workout_provider.dart';

class ExerciseSelectionScreen extends ConsumerStatefulWidget {
  const ExerciseSelectionScreen({super.key});

  @override
  ConsumerState<ExerciseSelectionScreen> createState() => _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends ConsumerState<ExerciseSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exercisesAsync = ref.watch(allExercisesProvider);

    return Scaffold(
      backgroundColor: GymTheme.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar Area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: GymTheme.cardSurface2,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: GymTheme.textPrimary, fontSize: 16.sp),
                        onChanged: (val) {
                          setState(() {
                            _searchQuery = val.toLowerCase();
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search or enter exercise name',
                          hintStyle: TextStyle(color: GymTheme.textSecondary, fontSize: 16.sp),
                          prefixIcon: Icon(LucideIcons.search, color: GymTheme.textSecondary, size: 20.sp),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(LucideIcons.x, color: GymTheme.textSecondary, size: 24.sp),
                  ),
                ],
              ),
            ),
            
            // Heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                'By Popularity',
                style: TextStyle(
                  color: GymTheme.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            
            // Exercise List
            Expanded(
              child: exercisesAsync.when(
                data: (exercises) {
                  final filteredExercises = exercises.where((ex) {
                    return ex.name.toLowerCase().contains(_searchQuery);
                  }).toList();
                  
                  if (filteredExercises.isEmpty) {
                    return Center(
                      child: Text(
                        'No exercises found.',
                        style: TextStyle(color: GymTheme.textSecondary, fontSize: 16.sp),
                      ),
                    );
                  }
                  
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 32.h),
                    itemCount: filteredExercises.length,
                    separatorBuilder: (context, index) => Divider(color: GymTheme.pillUnselected.withValues(alpha: 0.2), height: 1),
                    itemBuilder: (context, index) {
                      final ex = filteredExercises[index];
                      return _buildExerciseListItem(ex, ref, index);
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator(color: GymTheme.primaryAccent)),
                error: (err, stack) => Center(child: Text('Error: $err', style: TextStyle(color: GymTheme.textPrimary, fontSize: 16.sp))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseListItem(Exercise exercise, WidgetRef ref, int index) {
    // For demo purposes, we will mock "isSelected" based on active workout if needed, 
    // or just toggle it locally. The design shows a mix of Check and Plus.
    // We'll alternate just for visual fidelity to the screenshot.
    final bool isSelected = index % 3 != 0; // Fake state for demo

    // Fake progress value for demo
    final double progress = (index % 4 + 1) * 0.25;

    return InkWell(
      onTap: () {
        ref.read(activeWorkoutProvider.notifier).addExercise(exercise);
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            // Left Icon
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? GymTheme.primaryAccent : Colors.transparent,
                border: isSelected ? null : Border.all(color: GymTheme.primaryAccent, width: 2),
              ),
              alignment: Alignment.center,
              child: Icon(
                isSelected ? LucideIcons.check : LucideIcons.plus,
                color: isSelected ? AppColors.surfacePitchBlack : GymTheme.primaryAccent,
                size: 16.sp,
              ),
            ),
            SizedBox(width: 16.w),
            
            // Name
            Expanded(
              child: Text(
                exercise.name,
                style: TextStyle(color: GymTheme.textPrimary, fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
            
            // Right Ring Indicator
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 3,
                    color: GymTheme.cardSurface2,
                  ),
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 3,
                    color: GymTheme.primaryAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

