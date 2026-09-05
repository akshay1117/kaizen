import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_spacing.dart';

class AppBorders {
  static const BorderSide specular = BorderSide(
    color: AppColors.borderSpecular,
    width: 1.0,
  );

  static const BorderSide activeViolet = BorderSide(
    color: AppColors.borderActive,
    width: 1.0,
  );
  
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.surfaceElevatedLow,
    borderRadius: BorderRadius.circular(AppRadii.lg),
    border: Border.all(color: AppColors.borderSpecular, width: 1.0),
    // Optional shadow for subtle depth
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.2),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration glassDecoration = BoxDecoration(
    color: AppColors.glassmorphicFill,
    borderRadius: BorderRadius.circular(AppRadii.lg),
    border: Border.all(color: AppColors.borderSpecular, width: 1.0),
  );
}
