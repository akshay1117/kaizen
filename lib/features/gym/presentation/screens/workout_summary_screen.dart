import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/active_workout_provider.dart';

class WorkoutSummaryScreen extends ConsumerWidget {
  const WorkoutSummaryScreen({super.key});

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(activeWorkoutProvider);

    // Calculate total volume and sets
    double totalVolume = 0;
    int totalSets = 0;
    for (var ex in workoutState.exercises) {
      for (var set in ex.sets) {
        if (set.isCompleted) {
          totalVolume += (set.weight * set.reps);
          totalSets++;
        }
      }
    }

    return Scaffold(
      backgroundColor: GymTheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom Top Bar (moved beneath SafeArea)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.share2, color: GymTheme.primaryAccent),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      'Workout Complete',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: GymTheme.primaryAccent,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      workoutState.title,
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: GymTheme.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),
                    
                    // Stats Row
                    Row(
                      children: [
                        _buildStatCard('Duration', _formatDuration(workoutState.elapsedSeconds), LucideIcons.clock),
                        SizedBox(width: 16.w),
                        _buildStatCard('Volume', '${totalVolume.toStringAsFixed(0)} kg', LucideIcons.dumbbell),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        _buildStatCard('Sets', '$totalSets', LucideIcons.checkCircle),
                        SizedBox(width: 16.w),
                        _buildStatCard('Records', '2 PRs', LucideIcons.trophy),
                      ],
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Exercises Performed',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: GymTheme.textPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    
                    ...workoutState.exercises.map((ex) => _buildExerciseSummary(ex)),
                  ],
                ),
              ),
            ),
            
            // Bottom Action
            Container(
              padding: EdgeInsets.all(20.0.w),
              decoration: BoxDecoration(
                color: GymTheme.background,
                boxShadow: [
                  BoxShadow(color: GymTheme.background.withValues(alpha: 0.8), spreadRadius: 10, blurRadius: 20, offset: const Offset(0, -10)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GymTheme.primaryAccent,
                    foregroundColor: GymTheme.background,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  onPressed: () {
                    ref.read(activeWorkoutProvider.notifier).clearWorkout();
                    Navigator.pop(context); // Return to home
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: GymTheme.cardSurface2,
          borderRadius: BorderRadius.circular(GymTheme.cardRadius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: GymTheme.textSecondary, size: 16.sp),
                SizedBox(width: 8.w),
                Text(label, style: TextStyle(color: GymTheme.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.w600)),
              ],
            ),
            SizedBox(height: 12.h),
            Text(value, style: TextStyle(color: GymTheme.textPrimary, fontSize: 24.sp, fontWeight: FontWeight.bold, fontFamily: 'Montserrat')),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseSummary(ActiveWorkoutExercise exercise) {
    int completedSets = exercise.sets.where((s) => s.isCompleted).length;
    
    // Find best set (simplistic heuristic: max weight * reps)
    ActiveWorkoutSet? bestSet;
    double maxScore = 0;
    for (var s in exercise.sets) {
      if (s.isCompleted) {
        final score = s.weight * s.reps;
        if (score > maxScore) {
          maxScore = score;
          bestSet = s;
        }
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(GymTheme.cardRadius),
        border: Border.all(color: GymTheme.pillUnselected.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(exercise.name, style: TextStyle(color: GymTheme.textPrimary, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text('$completedSets sets completed', style: TextStyle(color: GymTheme.textSecondary, fontSize: 13.sp)),
              ],
            ),
          ),
          if (bestSet != null)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: GymTheme.cardSurface2,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                '${bestSet.weight.toStringAsFixed(0)} kg x ${bestSet.reps}',
                style: TextStyle(color: GymTheme.primaryAccent, fontWeight: FontWeight.bold, fontSize: 13.sp),
              ),
            ),
        ],
      ),
    );
  }
}
