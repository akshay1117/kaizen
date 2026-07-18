import 'package:flutter/material.dart';
import 'package:optimos/services/design_tokens.dart';

class ColorPickerGrid extends StatelessWidget {
  final List<Color> colors;
  final Color selectedColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerGrid({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: colors.map((color) {
        final isSelected = color.toARGB32() == selectedColor.toARGB32();
        return GestureDetector(
          onTap: () => onColorSelected(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
              border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                  : null,
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )
                : null,
          ),
        );
      }).toList(),
    );
  }
}
