import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';


class TrackingSegmentedControl extends StatelessWidget {
  final bool isQuantitative;
  final ValueChanged<bool> onChanged;

  const TrackingSegmentedControl({
    super.key,
    required this.isQuantitative,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfacePitchBlack,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.borderSpecular, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isQuantitative ? AppColors.surfaceElevatedMid : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.md - 2),
                ),
                child: Center(
                  child: Text(
                    'Step By Step',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: !isQuantitative ? FontWeight.w600 : FontWeight.w400,
                          color: !isQuantitative ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isQuantitative ? AppColors.surfaceElevatedMid : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.md - 2),
                ),
                child: Center(
                  child: Text(
                    'Custom Value',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isQuantitative ? FontWeight.w600 : FontWeight.w400,
                          color: isQuantitative ? AppColors.textPrimary : AppColors.textSecondary,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
