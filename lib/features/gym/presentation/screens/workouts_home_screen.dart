import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';


import 'package:kaizen/features/gym/presentation/widgets/new_workout_sheet.dart';
import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';
import 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';
import 'package:kaizen/core/widgets/streak_badge.dart';


import 'package:go_router/go_router.dart';

class WorkoutsHomeScreen extends ConsumerWidget {
  const WorkoutsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStreak = ref.watch(currentStreakProvider);

    return GlassScaffold(
      appBar: GlassAppBar(
        title: const Text(''),
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: EdgeInsets.only(left: 16.w, top: 32.h),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              height: 40.h,
              width: 40.h,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: GymTheme.cardSurface2,
                shape: BoxShape.circle,
              ),
              child: Icon(LucideIcons.settings, color: GymTheme.textPrimary, size: 20.sp),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(top: 32.h, right: 16.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreakBadge(
                  streak: currentStreak,
                  icon: LucideIcons.flame,
                  iconColor: GymTheme.textPrimary,
                ),
                SizedBox(width: 12.w),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20.r),
                  child: Container(
                    height: 38.h,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: GymTheme.cardSurface2,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text('Edit',
                        style: TextStyle(
                            color: GymTheme.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 60.h), // Clear GlassAppBar
                    Padding(
                      padding: EdgeInsets.only(left: 4.0.w, bottom: 16.0.h),
                      child: Text('My Workouts',
                          style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: GymTheme.textPrimary)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: GymTheme.cardBackground,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          // New Workout Item
                          _buildActionRow(
                            icon: LucideIcons.plus,
                            title: 'New Workout...',
                            subtitle: 'e.g., Upper Body, Leg Day, Monday Routine',
                            isFirst: true,
                            isLast: false,
                            isHighlight: true,
                            onTap: () => _showNewWorkoutSheet(context, ref),
                          ),
                          Divider(
                              color: GymTheme.pillUnselected,
                              height: 1,
                              indent: 64.w),
                          
                          // New Custom Plan Item
                          _buildActionRow(
                            icon: LucideIcons.wand2, // Wand icon for Custom Plan
                            title: 'New Custom Plan...',
                            isFirst: false,
                            isLast: false,
                            isHighlight: true,
                            isSimpleIcon: true,
                            onTap: () {},
                          ),
                          Divider(
                              color: GymTheme.pillUnselected,
                              height: 1,
                              indent: 64.w),
  
                          // My Exercises Item
                          Consumer(builder: (context, ref, child) {
                            final exercisesAsync = ref.watch(allExercisesProvider);
                            final exerciseCount = exercisesAsync.valueOrNull?.length.toString() ?? '...';
                            return _buildActionRow(
                              icon: LucideIcons.bookmark,
                              title: 'My Exercises',
                              isFirst: false,
                              isLast:
                                  false, // We will append dynamic workouts below
                              isHighlight: false,
                              isSimpleIcon: true,
                              onTap: () {
                                context.pushNamed('exercises-index');
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(exerciseCount,
                                      style: TextStyle(
                                          color: GymTheme.textSecondary,
                                          fontSize: 14.sp)),
                                  SizedBox(width: 8.w),
                                  Icon(LucideIcons.chevronRight,
                                      color: GymTheme.textSecondary, size: 14.sp),
                                ],
                              ),
                            );
                          }),
  
                          // Dynamic Workouts
                          Consumer(builder: (context, ref, child) {
                            final workoutsAsync =
                                ref.watch(ungroupedWorkoutsProvider);
                            return workoutsAsync.when(
                              data: (workouts) {
                                if (workouts.isEmpty) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(vertical: 32.h),
                                    child: Column(
                                      children: [
                                        Icon(LucideIcons.dumbbell, size: 48.sp, color: GymTheme.textSecondary.withValues(alpha: 0.3)),
                                        SizedBox(height: 16.h),
                                        Text('No workouts yet', style: TextStyle(color: GymTheme.textPrimary, fontSize: 16.sp, fontWeight: FontWeight.w600)),
                                        SizedBox(height: 8.h),
                                        Text('Tap "New Workout..." to get started.', style: TextStyle(color: GymTheme.textSecondary, fontSize: 13.sp)),
                                      ],
                                    ),
                                  );
                                }
                                return Column(
                                  children: workouts.map((workout) {
                                    final isLast = workouts.last == workout;
                                    return Column(
                                      children: [
                                        Divider(
                                            color: GymTheme.pillUnselected,
                                            height: 1,
                                            indent: 16.w),
                                        _buildActionRow(
                                          icon: LucideIcons.dumbbell,
                                          title: workout.name,
                                          subtitle: workout.description,
                                          isFirst: false,
                                          isLast: isLast,
                                          isHighlight: false,
                                          isSimpleIcon: true,
                                          onTap: () {
                                            context.pushNamed('workout-detail', extra: {
                                              'workoutId': workout.id,
                                              'workoutName': workout.name,
                                            });
                                          },
                                          trailing: Icon(LucideIcons.chevronRight,
                                              color: GymTheme.textSecondary,
                                              size: 14.sp),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                );
                              },
                              loading: () => const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator()),
                              error: (err, stack) => Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text('Error: $err')),
                            );
                          }),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24.h), // Added spacing between sections

                    // Workout Templates Section
                    Padding(
                      padding: EdgeInsets.only(left: 4.0.w, bottom: 16.0.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Workout Templates',
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: GymTheme.textPrimary)),
                          Icon(LucideIcons.chevronDown,
                              color: GymTheme.textSecondary, size: 20.sp),
                        ],
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12.w,
                      mainAxisSpacing: 12.h,
                      childAspectRatio: 1.2,
                      children: [
                        _buildTemplateCard('Grow Your\nUpper Body',
                            'Incline Bench Press, Seated Cable Row, D...'),
                        _buildTemplateCard('Burn Fat &\nBoost Endurance',
                            'Goblet Squat, Kettlebell Swing, Dum...'),
                        _buildTemplateCard('Build Powerful Legs\n& Glutes',
                            'Barbell Lunge, Leg Press, Leg Extension,...'),
                        _buildTemplateCard('Starting Strength',
                            'Squat, Bench Press, Overhead Press, Dea...'),
                      ],
                    ),
                    SizedBox(height: 32.h),

  
                    // Building Your Workouts
                    Container(
                      decoration: BoxDecoration(
                        color: GymTheme.cardBackground,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('BUILDING YOUR WORKOUTS',
                              style: TextStyle(
                                  color: GymTheme.textSecondary,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2)),
                          SizedBox(height: 16.h),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 4.h),
                                child: Icon(LucideIcons.book,
                                    color: GymTheme.textSecondary, size: 20.sp),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Organize by Favorites',
                                        style: TextStyle(
                                            color: GymTheme.textPrimary,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w600)),
                                    SizedBox(height: 4.h),
                                    Text(
                                        'Explore common workout structures to build your personalized tracking setup.',
                                        style: TextStyle(
                                            color: GymTheme.textSecondary,
                                            fontSize: 13.sp,
                                            height: 1.3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    String? subtitle,
    bool isFirst = false,
    bool isLast = false,
    bool isHighlight = false,
    bool isSimpleIcon = false,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? Radius.circular(16.r) : Radius.zero,
          bottom: isLast ? Radius.circular(16.r) : Radius.zero,
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Row(
            children: [
              if (!isSimpleIcon)
                Container(
                  width: 48.w,
                  height: 48.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: GymTheme.cardSurface2,
                      border: Border.all(
                          color: GymTheme.primaryAccent.withValues(alpha: 0.3),
                          width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: GymTheme.primaryAccent.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 0,
                        )
                      ]),
                  child: Icon(icon, color: GymTheme.primaryAccent, size: 20.sp),
                )
              else
                Container(
                  width: 48.w,
                  alignment: Alignment.center,
                  child: Icon(icon,
                      color: isHighlight
                          ? GymTheme.primaryAccent
                          : GymTheme.textPrimary,
                      size: 20.sp),
                ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            color: isHighlight
                                ? GymTheme.primaryAccent
                                : GymTheme.textPrimary,
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600)),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(subtitle,
                          style: TextStyle(
                              color: GymTheme.textSecondary, fontSize: 13.sp)),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
        ),
      ),
    );
  }

  void _showNewWorkoutSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NewWorkoutSheet(),
    );
  }

  Widget _buildTemplateCard(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  color: GymTheme.textPrimary,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.2)),
          Text(subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: GymTheme.textSecondary,
                  fontSize: 12.sp,
                  height: 1.3)),
        ],
      ),
    );
  }

}
