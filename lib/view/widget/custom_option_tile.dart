import 'package:flutter/material.dart';
import 'package:optimos/services/design_tokens.dart';

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
          color: DesignTokens.bgPrimary,
          borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
          border: Border.all(color: DesignTokens.borderPrimary, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: DesignTokens.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const Icon(
              Icons.chevron_right,
              color: DesignTokens.textPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
