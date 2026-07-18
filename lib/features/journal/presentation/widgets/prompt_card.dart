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
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF9b51e0).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.psychology_outlined, color: Color(0xFF9b51e0), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  prompt,
                  style: const TextStyle(
                    color: Color(0xFF9b51e0),
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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
