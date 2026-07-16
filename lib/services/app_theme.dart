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
      displayLarge: GoogleFonts.syne(fontSize: 28, fontWeight: FontWeight.w700, color: DesignTokens.textPrimary),
      displayMedium: GoogleFonts.syne(fontSize: 22, fontWeight: FontWeight.w600),
      displaySmall: GoogleFonts.syne(fontSize: 18, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.instrumentSans(fontSize: 14, color: DesignTokens.textSecondary),
      bodyMedium: GoogleFonts.instrumentSans(fontSize: 13, color: DesignTokens.textSecondary),
      labelLarge: GoogleFonts.dmMono(fontSize: 12, color: DesignTokens.textPrimary),
      labelMedium: GoogleFonts.dmMono(fontSize: 11, color: DesignTokens.textTertiary),
    ),
    cardTheme: CardThemeData(
      color: DesignTokens.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        side: BorderSide(color: DesignTokens.borderPrimary, width: 0.5),
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