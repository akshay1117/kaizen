import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/journal_provider.dart';

class JournalSearchBar extends ConsumerWidget {
  const JournalSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevatedHigh,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
              decoration: const InputDecoration(
                hintText: 'Search title, body, tags, mood...',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                border: InputBorder.none,
              ),
              onChanged: (value) {
                ref.read(journalFilterProvider.notifier).updateSearchQuery(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
