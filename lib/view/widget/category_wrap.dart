import 'package:flutter/material.dart';
import 'package:optimos/services/design_tokens.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? DesignTokens.bgTertiary : DesignTokens.bgPrimary,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.white : DesignTokens.borderPrimary,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getIconForCategory(cat),
                    size: 14,
                    color: isSelected ? Colors.white : DesignTokens.textSecondary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    cat,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isSelected ? Colors.white : DesignTokens.textSecondary,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: DesignTokens.borderPrimary,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  size: 14,
                  color: DesignTokens.textSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Create your own',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: DesignTokens.textSecondary,
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
        return Icons.attach_money;
      case 'fitness':
        return Icons.directions_run;
      case 'health':
        return Icons.favorite_border;
      case 'nutrition':
        return Icons.restaurant_menu;
      case 'social':
        return Icons.people_outline;
      case 'study':
        return Icons.school_outlined;
      case 'work':
        return Icons.work_outline;
      case 'morning':
        return Icons.wb_sunny_outlined;
      case 'day':
        return Icons.brightness_high_outlined;
      case 'evening':
        return Icons.nights_stay_outlined;
      default:
        return Icons.category_outlined;
    }
  }
}
