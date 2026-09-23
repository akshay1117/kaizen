import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class StatMini extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const StatMini({super.key, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.borderSpecular),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.dmMono(fontSize: 20, fontWeight: FontWeight.w500, color: color)),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textTertiary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}