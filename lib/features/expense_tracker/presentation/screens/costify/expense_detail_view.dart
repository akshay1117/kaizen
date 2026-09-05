import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ExpenseDetailView extends StatelessWidget {
  final String title;
  final String amount;
  final String category;
  final String date;
  final VoidCallback onDelete;

  const ExpenseDetailView({
    super.key, 
    this.title = 'Mango juice',
    this.amount = '-₹30.00',
    this.category = 'Personal',
    this.date = 'March 18, 2026 at 11:58 PM',
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.surfaceObsidian,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 16),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: const Text('Detail', style: TextStyle(color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            // Hero Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceObsidian,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Color(0xFF000000),
                        child: Text('✨', style: TextStyle(fontSize: 20)),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Added by', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text('Akshaykrishnantv', style: TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    amount.replaceAll('-', ''), 
                    style: const TextStyle(color: Color(0xFFF7931A), fontSize: 32, fontWeight: FontWeight.bold)
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_offer_outlined, color: AppColors.textSecondary, size: 16),
                          const SizedBox(width: 4),
                          Text(category, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      Text(date, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Comments Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceObsidian,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Comments', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('No comments available.', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF000000),
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.centerLeft,
                          child: const Text('Add a comment...', style: TextStyle(color: Color(0xFF5C5C5E), fontSize: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: AppColors.accentViolet,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.send, color: AppColors.textPrimary, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Attachments Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceObsidian,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Attachments', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.attach_file, color: AppColors.textSecondary, size: 16),
                      SizedBox(width: 8),
                      Text('No attachments', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentViolet,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                icon: const Icon(Icons.edit, color: AppColors.textPrimary, size: 18),
                label: const Text('Edit expense', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                icon: const Icon(Icons.delete_outline, color: AppColors.textPrimary, size: 20),
                label: const Text('Delete expense', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: onDelete,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
