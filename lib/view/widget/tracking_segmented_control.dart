import 'package:flutter/material.dart';
import 'package:optimos/services/design_tokens.dart';

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
        color: DesignTokens.bgPrimary,
        borderRadius: BorderRadius.circular(DesignTokens.radiusMedium),
        border: Border.all(color: DesignTokens.borderPrimary, width: 1),
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
                  color: !isQuantitative ? DesignTokens.bgTertiary : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMedium - 2),
                ),
                child: Center(
                  child: Text(
                    'Step By Step',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: !isQuantitative ? FontWeight.w600 : FontWeight.w400,
                          color: !isQuantitative ? DesignTokens.textPrimary : DesignTokens.textSecondary,
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
                  color: isQuantitative ? DesignTokens.bgTertiary : Colors.transparent,
                  borderRadius: BorderRadius.circular(DesignTokens.radiusMedium - 2),
                ),
                child: Center(
                  child: Text(
                    'Custom Value',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isQuantitative ? FontWeight.w600 : FontWeight.w400,
                          color: isQuantitative ? DesignTokens.textPrimary : DesignTokens.textSecondary,
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
