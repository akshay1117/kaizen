import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LocationChip extends StatelessWidget {
  final String location;
  const LocationChip({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedHigh,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('📍', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            location,
            style: TextStyle(
              color: Colors.grey[300],
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
