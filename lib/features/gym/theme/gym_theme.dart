import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GymTheme {
  // Brand colors
  static const Color background = Color(0xFF000000);
  static const Color cardBackground = Color(0xFF1C1C1E);
  static const Color primaryAccent = Color(0xFF30D158);
  static const Color weightAccent = Color(0xFFFF9F0A);
  static const Color volumeAccent = Color(0xFF32ADE6);
  static const Color destructive = Color(0xFFFF453A);
  
  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);

  // Pill segment colors
  static const Color pillUnselected = Color(0x338E8E93); // translucent dark grey
  static const Color pillSelected = Color(0xFFFFFFFF);
  static const Color pillTextSelected = Color(0xFF000000);
  
  // Radii
  static const double cardRadius = 24.0;
  static const double pillRadius = 100.0;

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
        displayLarge: GoogleFonts.inter(fontSize: 34, fontWeight: FontWeight.w700, color: textPrimary),
        displayMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: textPrimary),
        titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: textPrimary),
        bodyLarge: GoogleFonts.inter(fontSize: 17, color: textPrimary),
        bodyMedium: GoogleFonts.inter(fontSize: 15, color: textSecondary),
        labelLarge: GoogleFonts.inter(fontSize: 13, color: textPrimary),
        labelMedium: GoogleFonts.inter(fontSize: 11, color: textSecondary),
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
}
