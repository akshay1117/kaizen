import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GymTheme {
  // Brand colors
  static const Color background = AppColors.surfacePitchBlack;
  static const Color cardBackground = AppColors.surfaceObsidian;
  static const Color cardSurface2 = AppColors.surfaceElevatedHigh;
  static const Color primaryAccent = AppColors.accentViolet;
  static const Color weightAccent = AppColors.accentNeon;
  static const Color volumeAccent = AppColors.accentLavender;
  static const Color destructive = AppColors.semanticUrgent;
  
  // Text colors
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;

  // Pill segment colors
  static const Color pillUnselected = Color(0x338E8E93); // translucent dark grey
  static const Color pillSelected = AppColors.textPrimary;
  static const Color pillTextSelected = Color(0xFF000000);
  
  // Radii
  static double get cardRadius => 16.r;
  static double get pillRadius => 100.r;

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.dark(
        primary: primaryAccent,
        secondary: weightAccent,
        surface: cardBackground,
        error: destructive,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(fontSize: 34.sp, fontWeight: FontWeight.w700, color: textPrimary),
        displayMedium: GoogleFonts.montserrat(fontSize: 28.sp, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: GoogleFonts.montserrat(fontSize: 22.sp, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 17.sp, color: textPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 15.sp, color: textSecondary),
        labelLarge: GoogleFonts.inter(fontSize: 13.sp, color: textPrimary),
        labelMedium: GoogleFonts.inter(fontSize: 11.sp, color: textSecondary),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(
        color: textPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primaryAccent,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Light theme definition
  static const Color lightBackground = Color(0xFFF2F2F7);
  static const Color lightCardBackground = AppColors.textPrimary;
  static const Color lightTextPrimary = Color(0xFF000000);
  static const Color lightTextSecondary = AppColors.textSecondary;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      primaryColor: primaryAccent,
      colorScheme: const ColorScheme.light(
        primary: primaryAccent,
        secondary: weightAccent,
        surface: lightCardBackground,
        error: destructive,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.montserrat(fontSize: 34.sp, fontWeight: FontWeight.w700, color: lightTextPrimary),
        displayMedium: GoogleFonts.montserrat(fontSize: 28.sp, fontWeight: FontWeight.w600, color: lightTextPrimary),
        titleLarge: GoogleFonts.montserrat(fontSize: 22.sp, fontWeight: FontWeight.w600, color: lightTextPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 17.sp, color: lightTextPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 15.sp, color: lightTextSecondary),
        labelLarge: GoogleFonts.inter(fontSize: 13.sp, color: lightTextPrimary),
        labelMedium: GoogleFonts.inter(fontSize: 11.sp, color: lightTextSecondary),
      ),
      cardTheme: CardThemeData(
        color: lightCardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
        margin: EdgeInsets.zero,
      ),
      iconTheme: const IconThemeData(
        color: lightTextPrimary,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: lightCardBackground,
        selectedItemColor: primaryAccent,
        unselectedItemColor: lightTextSecondary,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  // Recovery heat scale colors
  static const Color muscleJustTrained = Color(0xFFFF3B30); // Bright Red
  static const Color muscleRested = Color(0xFF3A3A3C); // Dark Grey / Uncolored
  
  // Tabular font style helper for weights and reps
  static TextStyle tabularStyle(TextStyle baseStyle) {
    return baseStyle.copyWith(
      fontFeatures: const [
        // FontFeature.tabularFigures() equivalent for some fonts
        // Using OpenType tag 'tnum' for tabular numbers
        FontFeature.tabularFigures(), 
      ],
    );
  }
}
