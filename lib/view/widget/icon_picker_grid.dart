import 'package:flutter/material.dart';
import 'package:optimos/services/design_tokens.dart';

class IconPickerGrid extends StatelessWidget {
  final String selectedIcon;
  final ValueChanged<String> onIconSelected;
  final List<Map<String, dynamic>> icons;

  const IconPickerGrid({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        final iconData = icons[index];
        final isSelected = iconData['name'] == selectedIcon;
        return GestureDetector(
          onTap: () => onIconSelected(iconData['name']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                iconData['icon'],
                color: isSelected ? Colors.white : DesignTokens.textTertiary,
                size: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}
