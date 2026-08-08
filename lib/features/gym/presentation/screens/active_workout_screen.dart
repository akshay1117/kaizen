import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/active_workout_provider.dart';
import 'package:kaizen/features/gym/presentation/screens/exercise_selection_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/workout_summary_screen.dart';

class ActiveWorkoutScreen extends ConsumerStatefulWidget {
  const ActiveWorkoutScreen({super.key});

  @override
  ConsumerState<ActiveWorkoutScreen> createState() => _ActiveWorkoutScreenState();
}

class _ActiveWorkoutScreenState extends ConsumerState<ActiveWorkoutScreen> {
  
  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final workoutState = ref.watch(activeWorkoutProvider);

    return Scaffold(
      backgroundColor: GymTheme.background,
      appBar: AppBar(
        backgroundColor: GymTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronDown, color: GymTheme.textPrimary),
          onPressed: () {
            // Usually this would minimize the workout to continue navigating the app
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            Text(
              workoutState.title,
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
                color: GymTheme.textPrimary,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              _formatDuration(workoutState.elapsedSeconds),
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                color: GymTheme.primaryAccent,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              ref.read(activeWorkoutProvider.notifier).finishWorkout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WorkoutSummaryScreen()),
              );
            },
            style: TextButton.styleFrom(
              backgroundColor: GymTheme.cardSurface2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            ),
            child: const Text('Finish', style: TextStyle(color: GymTheme.primaryAccent, fontWeight: FontWeight.bold)),
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: workoutState.exercises.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.dumbbell, size: 64.sp, color: GymTheme.pillUnselected),
                  SizedBox(height: 16.h),
                  const Text('No exercises added yet.', style: TextStyle(color: GymTheme.textSecondary)),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h).copyWith(bottom: 100),
              itemCount: workoutState.exercises.length,
              separatorBuilder: (context, index) => SizedBox(height: 24.h),
              itemBuilder: (context, index) {
                final exercise = workoutState.exercises[index];
                return _buildExerciseCard(exercise, ref);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: GymTheme.primaryAccent,
        foregroundColor: GymTheme.background,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExerciseSelectionScreen()),
          );
        },
        icon: const Icon(LucideIcons.plus),
        label: const Text('Add Exercise', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildExerciseCard(ActiveWorkoutExercise exercise, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(GymTheme.cardRadius),
        border: Border.all(color: GymTheme.pillUnselected.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Exercise Header
          Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    exercise.name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: GymTheme.primaryAccent,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.moreHorizontal, color: GymTheme.textSecondary),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          
          // Table Headers
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0.w),
            child: Row(
              children: [
                SizedBox(width: 30, child: Text('SET', style: TextStyle(color: GymTheme.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('PREVIOUS', style: TextStyle(color: GymTheme.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('kg', textAlign: TextAlign.center, style: TextStyle(color: GymTheme.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.bold))),
                Expanded(flex: 2, child: Text('REPS', textAlign: TextAlign.center, style: TextStyle(color: GymTheme.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.bold))),
                SizedBox(width: 40, child: Icon(LucideIcons.check, size: 16.sp, color: GymTheme.textSecondary)),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          
          // Sets List
          ...exercise.sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;
            return _buildSetRow(exercise.id, set, index + 1, ref);
          }),
          
          // Add Set Button
          InkWell(
            onTap: () {
              ref.read(activeWorkoutProvider.notifier).addSet(exercise.id);
            },
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.plus, color: GymTheme.textSecondary, size: 18.sp),
                  SizedBox(width: 8.w),
                  const Text('Add Set', style: TextStyle(color: GymTheme.textSecondary, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetRow(String exerciseId, ActiveWorkoutSet set, int setNumber, WidgetRef ref) {
    final bgColor = set.isCompleted ? GymTheme.primaryAccent.withValues(alpha: 0.1) : Colors.transparent;
    
    return Container(
      color: bgColor,
      padding: EdgeInsets.symmetric(horizontal: 16.0.w, vertical: 8.0.h),
      child: Row(
        children: [
          // Set Number
          SizedBox(
            width: 30,
            child: Text(
              '$setNumber',
              style: TextStyle(
                color: set.isCompleted ? GymTheme.primaryAccent : GymTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Previous
          Expanded(
            flex: 2,
            child: Text(
              '60 kg x 10', // Placeholder for now
              style: TextStyle(color: GymTheme.textSecondary, fontSize: 13.sp),
            ),
          ),
          
          // Weight Input
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: GymTheme.cardSurface2,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextFormField(
                key: ValueKey('weight_${set.id}'),
                initialValue: set.weight > 0 ? set.weight.toString().replaceAll(RegExp(r'([.]*0)(?!.*\d)'), '') : '',
                textAlign: TextAlign.center,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                style: const TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                onChanged: (val) {
                  ref.read(activeWorkoutProvider.notifier).updateSet(exerciseId, set.id, weight: double.tryParse(val) ?? 0);
                },
              ),
            ),
          ),
          
          // Reps Input
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: GymTheme.cardSurface2,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: TextFormField(
                key: ValueKey('reps_${set.id}'),
                initialValue: set.reps > 0 ? set.reps.toString() : '',
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                ),
                onChanged: (val) {
                  ref.read(activeWorkoutProvider.notifier).updateSet(exerciseId, set.id, reps: int.tryParse(val) ?? 0);
                },
              ),
            ),
          ),
          
          // Checkmark
          SizedBox(
            width: 40,
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: set.isCompleted ? GymTheme.primaryAccent : GymTheme.cardSurface2,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(
                  LucideIcons.check,
                  size: 16.sp,
                  color: set.isCompleted ? GymTheme.background : GymTheme.textSecondary,
                ),
              ),
              onPressed: () {
                ref.read(activeWorkoutProvider.notifier).toggleSetCompletion(exerciseId, set.id);
              },
            ),
          ),
        ],
      ),
    );
  }
}
