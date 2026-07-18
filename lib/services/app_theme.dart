import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:optimos/services/design_tokens.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DesignTokens.bgPrimary,
    primaryColor: DesignTokens.accentGym,
    colorScheme: const ColorScheme.dark(
      primary: DesignTokens.accentGym,
      secondary: DesignTokens.accentHabit,
      surface: DesignTokens.bgSecondary,
      error: DesignTokens.accentBoxing,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, color: DesignTokens.textPrimary),
      displayMedium: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(fontSize: 14, color: DesignTokens.textSecondary),
      bodyMedium: GoogleFonts.inter(fontSize: 13, color: DesignTokens.textSecondary),
      labelLarge: GoogleFonts.inter(fontSize: 12, color: DesignTokens.textPrimary),
      labelMedium: GoogleFonts.inter(fontSize: 11, color: DesignTokens.textTertiary),
    ),
    cardTheme: CardThemeData(
      color: DesignTokens.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: const BorderSide(color: DesignTokens.borderPrimary, width: 0.5),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: DesignTokens.bgTertiary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}