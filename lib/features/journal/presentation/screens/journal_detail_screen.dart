import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/journal_provider.dart';
import '../widgets/journal_image.dart';
import '../widgets/journal_audio_player.dart';
import '../widgets/mood_chip.dart';
import '../widgets/location_chip.dart';
import '../widgets/tag_chip.dart';

class JournalDetailScreen extends ConsumerWidget {
  final String journalId;

  const JournalDetailScreen({super.key, required this.journalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesState = ref.watch(journalListProvider);
    final entries = entriesState.value ?? [];
    final entry = entries.firstWhere(
      (e) => e.id == journalId,
      orElse: () => entries.isNotEmpty ? entries.first : throw Exception('Journal not found'),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textPrimary : AppColors.surfacePitchBlack;
    final bodyColor = isDark ? Colors.grey[300] : Colors.grey[800];

    return GlassScaffold(
      backgroundColor: isDark ? const Color(0xFF141415) : AppColors.textPrimary,
      appBar: GlassAppBar(
        backgroundColor: Colors.transparent,

        actions: [
          IconButton(
            icon: Icon(
              entry.favorite ? Icons.favorite : Icons.favorite_border,
              color: entry.favorite ? AppColors.semanticUrgent : Colors.grey,
            ),
            onPressed: () {
              ref.read(journalListProvider.notifier).toggleFavorite(entry.id);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Edit functionality
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images if any
            if (entry.images.isNotEmpty) ...[
              JournalImageWidget(
                imageUrl: entry.images.first,
                heroTag: 'img_${entry.id}',
              ),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Mood & Location
            Row(
              children: [
                MoodChip(mood: entry.mood),
                const SizedBox(width: AppSpacing.sm * 1.5),
                if (entry.location != null && entry.location!.isNotEmpty)
                  LocationChip(location: entry.location!),
              ],
            ),
            const SizedBox(height: AppSpacing.md * 1.25),

            // Title
            if (entry.title.isNotEmpty) ...[
              Text(
                entry.title,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],

            // Audio Player
            if (entry.audioPath != null && entry.audioPath!.isNotEmpty) ...[
              AudioPlayerWidget(audioPath: entry.audioPath!),
              const SizedBox(height: AppSpacing.lg),
            ],

            // Body
            if (entry.body.isNotEmpty) ...[
              Text(
                entry.body,
                style: TextStyle(
                  fontSize: 18,
                  color: bodyColor,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],

            // Tags
            if (entry.tags.isNotEmpty) ...[
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final tag in entry.tags) TagChip(tag: tag),
                ],
              ),
              const SizedBox(height: AppSpacing.xxl),
            ],

            // Created / Updated Dates
            Divider(color: Colors.grey[800]),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Created: ${DateFormat('MMMM d, yyyy • h:mm a').format(entry.createdAt)}',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
            const SizedBox(height: 6),
            Text(
              'Updated: ${DateFormat('MMMM d, yyyy • h:mm a').format(entry.updatedAt)}',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
