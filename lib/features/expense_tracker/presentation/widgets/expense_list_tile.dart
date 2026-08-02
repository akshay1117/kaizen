import 'package:flutter/material.dart';

class ExpenseListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;
  final String username;
  final VoidCallback onTap;

  const ExpenseListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    this.username = 'Akshaykrishnantv',
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Avatar and Username
            Row(
              children: [
                const CircleAvatar(
                  radius: 10,
                  backgroundColor: Color(0xFF3A3A3C),
                  child: Icon(Icons.person, size: 12, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text(
                  username,
                  style: const TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Main Row: Title/Subtitle and Amount
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Color(0xFF8E8E93),
                          fontSize: 14,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      amount,
                      style: const TextStyle(
                        color: Color(0xFFFF3B30), // Red for expenses
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.chevron_right,
                      color: Color(0xFF8E8E93),
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}
