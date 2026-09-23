import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PromptCard extends StatelessWidget {
  final String prompt;
  final String response;

  const PromptCard({
    super.key,
    required this.prompt,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedHigh,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accentViolet.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: AppColors.accentViolet, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  prompt,
                  style: const TextStyle(
                    color: AppColors.accentViolet,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm * 1.5),
          Text(
            response,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 16,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
