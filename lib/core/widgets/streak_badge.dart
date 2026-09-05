import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class StreakBadge extends StatelessWidget {
  final int streak;
  final IconData icon;
  final Color iconColor;

  const StreakBadge({
    super.key,
    required this.streak,
    required this.icon,
    this.iconColor = GymTheme.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: GymTheme.cardSurface2,
        borderRadius: BorderRadius.circular(19.h),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.sp, color: iconColor),
          SizedBox(width: 4.w),
          Text(
            '$streak',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
