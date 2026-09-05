import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String tag;
  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentViolet.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.accentViolet.withValues(alpha: 0.4)),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          color: AppColors.accentViolet,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
