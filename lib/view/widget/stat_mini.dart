import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kaizen/services/design_tokens.dart';

class StatMini extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const StatMini({super.key, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: DesignTokens.bgSecondary,
        borderRadius: BorderRadius.circular(DesignTokens.radiusLarge),
        border: Border.all(color: DesignTokens.borderPrimary),
      ),
      child: Column(
        children: [
          Text(value, style: GoogleFonts.dmMono(fontSize: 20, fontWeight: FontWeight.w500, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: DesignTokens.textTertiary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}