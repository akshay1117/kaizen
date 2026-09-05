import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:drift/drift.dart' as drift;
import 'package:kaizen/features/gym/presentation/screens/workout_detail_screen.dart';

class NewWorkoutSheet extends ConsumerStatefulWidget {
  const NewWorkoutSheet({super.key});

  @override
  ConsumerState<NewWorkoutSheet> createState() => _NewWorkoutSheetState();
}

class _NewWorkoutSheetState extends ConsumerState<NewWorkoutSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  
  final List<Color> _colors = [
    AppColors.semanticUrgent,
    Colors.orangeAccent,
    Colors.yellowAccent,
    GymTheme.primaryAccent,
    AppColors.accentViolet,
    Colors.purpleAccent,
    Colors.grey,
    AppColors.textPrimary, // placeholder for rainbow
  ];
  
  int _selectedColorIndex = 3; // Default to green

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() async {
    final name = _nameController.text.trim();
    final desc = _descController.text.trim();
    if (name.isNotEmpty) {
      final id = const Uuid().v4();
      final dao = ref.read(workoutDaoProvider);
      final nav = Navigator.of(context);
      await dao.insertWorkout(WorkoutsCompanion.insert(
        id: drift.Value(id),
        name: name,
        description: desc.isNotEmpty ? drift.Value(desc) : const drift.Value.absent(),
      ));

      nav.pop(); // Close sheet
      nav.push(
        MaterialPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workoutId: id,
            workoutName: name,
          ),
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: GymTheme.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: const BoxDecoration(
                        color: GymTheme.cardSurface2,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(LucideIcons.x, size: 20.sp, color: GymTheme.textSecondary),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'New Workout',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: GymTheme.textPrimary,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: GymTheme.primaryAccent,
                      foregroundColor: AppColors.surfacePitchBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(GymTheme.pillRadius),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      elevation: 0,
                    ),
                    onPressed: _save,
                    icon: Icon(LucideIcons.check, size: 16.sp),
                    label: Text(
                      'save',
                      style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),

              // Icon
              Center(
                child: Container(
                  width: 100.w,
                  height: 100.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: _colors[_selectedColorIndex], width: 4.w),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    LucideIcons.bookOpen,
                    size: 50.sp,
                    color: _colors[_selectedColorIndex],
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              // Name Input
              Text('Name', style: TextStyle(color: GymTheme.textPrimary, fontSize: 15.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              TextField(
                controller: _nameController,
                style: TextStyle(color: GymTheme.textPrimary, fontSize: 17.sp),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: GymTheme.cardSurface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Organize by workout, muscle group, day of the week, etc.',
                style: TextStyle(color: GymTheme.textSecondary, fontSize: 13.sp),
              ),
              SizedBox(height: 24.h),

              // Description Input
              Text('Description', style: TextStyle(color: GymTheme.textPrimary, fontSize: 15.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              TextField(
                controller: _descController,
                maxLines: 4,
                style: TextStyle(color: GymTheme.textPrimary, fontSize: 17.sp),
                decoration: InputDecoration(
                  hintText: 'Set a description or plan',
                  hintStyle: TextStyle(color: GymTheme.textSecondary, fontSize: 17.sp),
                  filled: true,
                  fillColor: GymTheme.cardSurface2,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                ),
              ),
              SizedBox(height: 32.h),

              // Colors
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_colors.length, (index) {
                  final isSelected = index == _selectedColorIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColorIndex = index),
                    child: Container(
                      width: 36.w,
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: _colors[index],
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: _colors[index].withValues(alpha: 0.5), width: 4.w)
                            : null,
                      ),
                      // For rainbow, you'd use a SweepGradient decoration instead of solid color, but using white placeholder for now.
                      child: index == _colors.length - 1
                          ? Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: SweepGradient(
                                  colors: [AppColors.semanticUrgent, Colors.yellow, AppColors.semanticPositive, Colors.blue, Colors.purple, AppColors.semanticUrgent],
                                ),
                              ),
                            )
                          : null,
                    ),
                  );
                }),
              ),
              SizedBox(height: 32.h),

              // Group
              Text('Group', style: TextStyle(color: GymTheme.textPrimary, fontSize: 15.sp, fontWeight: FontWeight.bold)),
              SizedBox(height: 8.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: GymTheme.cardSurface2,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('No Group', style: TextStyle(color: GymTheme.textPrimary, fontSize: 17.sp)),
                    Icon(LucideIcons.chevronsUpDown, color: GymTheme.textSecondary, size: 20.sp),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Optional: Organize this workout into a group',
                style: TextStyle(color: GymTheme.textSecondary, fontSize: 13.sp),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}
