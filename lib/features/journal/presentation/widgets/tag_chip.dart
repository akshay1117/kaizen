import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  final String tag;
  const TagChip({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF9b51e0).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF9b51e0).withValues(alpha: 0.4)),
      ),
      child: Text(
        '#$tag',
        style: const TextStyle(
          color: Color(0xFF9b51e0),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
