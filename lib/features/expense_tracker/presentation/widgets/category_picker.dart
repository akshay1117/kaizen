import 'package:flutter/material.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';

class CategoryPicker extends StatelessWidget {
  final List<ExpenseCategory> categories;
  final String? selectedCategoryId;
  final Function(String) onCategorySelected;

  const CategoryPicker({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemBuilder: (context, index) {
        if (index == categories.length) {
          return _buildAddCategoryTile();
        }
        return _buildCategoryTile(categories[index]);
      },
    );
  }

  Widget _buildCategoryTile(ExpenseCategory category) {
    final isSelected = selectedCategoryId == category.id;
    Color color = Colors.blue;
    try {
      if (category.colorHex.length == 6) {
        color = Color(int.parse('0xFF${category.colorHex}'));
      }
    } catch (_) {}
    
    IconData getIcon(String name) {
      switch (name) {
        case 'utensils': return Icons.restaurant;
        case 'car': return Icons.directions_car;
        case 'shopping-bag': return Icons.shopping_bag;
        case 'briefcase': return Icons.work;
        default: return Icons.category;
      }
    }

    return GestureDetector(
      onTap: () => onCategorySelected(category.id),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: isSelected ? Border.all(color: color, width: 2) : null,
            ),
            child: Icon(getIcon(category.icon), color: color),
          ),
          const SizedBox(height: 8),
          Text(category.name, style: const TextStyle(color: Colors.white, fontSize: 12), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }

  Widget _buildAddCategoryTile() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: const BoxDecoration(
            color: Color(0xFF2A2A2A),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        const SizedBox(height: 8),
        const Text('Add', style: TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}
