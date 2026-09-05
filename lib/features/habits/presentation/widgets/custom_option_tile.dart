import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class CustomOptionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const CustomOptionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfacePitchBlack,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
