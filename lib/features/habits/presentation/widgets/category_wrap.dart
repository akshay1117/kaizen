import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CategoryWrap extends StatelessWidget {
  final List<String> availableCategories;
  final List<String> selectedCategories;
  final ValueChanged<String> onToggleCategory;
  final VoidCallback onCreateNew;

  const CategoryWrap({
    super.key,
    required this.availableCategories,
    required this.selectedCategories,
    required this.onToggleCategory,
    required this.onCreateNew,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...availableCategories.map((cat) {
          final isSelected = selectedCategories.contains(cat);
          return GestureDetector(
            onTap: () => onToggleCategory(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surfaceElevatedHigh : AppColors.surfacePitchBlack,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(
                  color: isSelected ? AppColors.textPrimary : AppColors.surfaceElevatedHigh,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForCategory(cat),
                    size: 16,
                    color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    cat,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          );
        }),
        GestureDetector(
          onTap: onCreateNew,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfacePitchBlack,
              borderRadius: BorderRadius.circular(AppRadii.md),
              border: Border.all(
                color: AppColors.surfaceElevatedHigh,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Create your own',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'art':
        return Icons.palette_outlined;
      case 'finances':
        return Icons.account_balance_wallet_outlined;
      case 'fitness':
        return Icons.directions_bike_outlined;
      case 'health':
        return Icons.favorite_border;
      case 'nutrition':
        return Icons.restaurant_outlined;
      case 'social':
        return Icons.people_outline;
      case 'study':
        return Icons.school_outlined;
      case 'work':
        return Icons.work_outline;
      case 'other':
        return Icons.diamond_outlined;
      case 'morning':
        return Icons.wb_cloudy_outlined;
      case 'day':
        return Icons.light_mode_outlined;
      case 'evening':
        return Icons.dark_mode_outlined;
      default:
        return Icons.label_outline;
    }
  }
}
