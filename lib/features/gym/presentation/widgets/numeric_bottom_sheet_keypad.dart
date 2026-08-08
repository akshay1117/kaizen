import 'package:flutter/material.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class NumericBottomSheetKeypad extends StatelessWidget {
  final String title;
  final String initialValue;
  final ValueChanged<String> onValueChanged;
  final VoidCallback onSave;

  const NumericBottomSheetKeypad({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onValueChanged,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? GymTheme.cardBackground : GymTheme.lightCardBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? GymTheme.textSecondary.withValues(alpha: 0.5) : GymTheme.lightTextSecondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.titleLarge),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            initialValue,
            style: GymTheme.tabularStyle(
              theme.textTheme.displayLarge!.copyWith(
                color: theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 16),
          // A simple 3x3 grid for numbers + bottom row
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              if (index == 9) {
                return _buildKey(context, '.', isDark);
              } else if (index == 10) {
                return _buildKey(context, '0', isDark);
              } else if (index == 11) {
                return _buildKey(context, 'DEL', isDark, isAction: true);
              } else {
                return _buildKey(context, '${index + 1}', isDark);
              }
            },
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildKey(BuildContext context, String label, bool isDark, {bool isAction = false}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        // Mock tap handler
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? GymTheme.background : GymTheme.lightBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: theme.textTheme.titleLarge?.copyWith(
            color: isAction ? theme.colorScheme.error : null,
          ),
        ),
      ),
    );
  }
}
