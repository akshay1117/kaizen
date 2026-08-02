import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../domain/models/journal_entry.dart';
import '../../providers/journal_provider.dart';
import 'journal_image.dart';
import 'journal_audio_player.dart';
import 'mood_chip.dart';
import 'prompt_card.dart';
import 'location_chip.dart';
import 'tag_chip.dart';

class JournalCard extends ConsumerWidget {
  final JournalEntry entry;

  const JournalCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final bodyColor = isDark ? Colors.grey[300] : Colors.grey[800];
    final dateColor = isDark ? Colors.grey[500] : Colors.grey[600];

    return Dismissible(
      key: Key(entry.id),
      direction: DismissDirection.horizontal,
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.amber[700],
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.favorite, color: Colors.white, size: 28),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          // Swipe Right -> Favorite
          ref.read(journalListProvider.notifier).toggleFavorite(entry.id);
          return false; // don't dismiss the card, just toggle favorite
        } else {
          // Swipe Left -> Delete with confirmation dialog
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => DeleteConfirmationDialog(entry: entry),
          );
          return confirm ?? false;
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          ref.read(journalListProvider.notifier).deleteEntry(entry.id);
        }
      },
      child: Card(
        color: bgColor,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: isDark ? BorderSide(color: Colors.grey.withValues(alpha: 0.15)) : BorderSide.none,
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            context.push('/journal/detail/${entry.id}');
          },
          onLongPress: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) => BottomActionSheet(entry: entry),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Mood / Favorite
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MoodChip(mood: entry.mood),
                    IconButton(
                      icon: Icon(
                        entry.favorite ? Icons.favorite : Icons.favorite_border,
                        color: entry.favorite ? Colors.redAccent : Colors.grey,
                      ),
                      onPressed: () {
                        ref.read(journalListProvider.notifier).toggleFavorite(entry.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Prompt if available
                if (entry.prompt != null && entry.prompt!.isNotEmpty) ...[
                  PromptCard(prompt: entry.prompt!, response: entry.body),
                  const SizedBox(height: 16),
                ] else ...[
                  // Normal Title & Body
                  if (entry.title.isNotEmpty) ...[
                    Text(
                      entry.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (entry.body.isNotEmpty) ...[
                    Text(
                      entry.body,
                      style: TextStyle(
                        fontSize: 16,
                        color: bodyColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ],

                // Image if available
                if (entry.images.isNotEmpty) ...[
                  JournalImageWidget(
                    imageUrl: entry.images.first,
                    heroTag: 'img_${entry.id}',
                  ),
                  const SizedBox(height: 16),
                ],

                // Audio if available
                if (entry.audioPath != null && entry.audioPath!.isNotEmpty) ...[
                  AudioPlayerWidget(audioPath: entry.audioPath!),
                  const SizedBox(height: 16),
                ],

                // Tags & Location
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (entry.location != null && entry.location!.isNotEmpty)
                      LocationChip(location: entry.location!),
                    for (final tag in entry.tags) TagChip(tag: tag),
                  ],
                ),
                const SizedBox(height: 16),

                // Timestamp
                Text(
                  DateFormat('EEEE, MMMM d').format(entry.createdAt),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: dateColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final JournalEntry entry;
  const DeleteConfirmationDialog({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2C2C2E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Text('Delete Journal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to delete this journal entry? This action cannot be undone.', style: TextStyle(color: Colors.grey)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Delete', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}

class BottomActionSheet extends ConsumerWidget {
  final JournalEntry entry;
  const BottomActionSheet({super.key, required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Color(0xFF2C2C2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[600], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          _buildActionItem(
            icon: Icons.edit_outlined,
            title: 'Edit',
            onTap: () {
              Navigator.of(context).pop();
              // In a full app, navigate to edit screen
            },
          ),
          _buildActionItem(
            icon: Icons.copy_outlined,
            title: 'Duplicate',
            onTap: () {
              Navigator.of(context).pop();
              final duplicated = entry.copyWith(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: '${entry.title} (Copy)',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              ref.read(journalListProvider.notifier).addEntry(duplicated);
            },
          ),
          _buildActionItem(
            icon: entry.favorite ? Icons.favorite : Icons.favorite_border,
            title: entry.favorite ? 'Unfavorite' : 'Favorite',
            onTap: () {
              Navigator.of(context).pop();
              ref.read(journalListProvider.notifier).toggleFavorite(entry.id);
            },
          ),
          _buildActionItem(
            icon: Icons.share_outlined,
            title: 'Share',
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          _buildActionItem(
            icon: Icons.delete_outline,
            title: 'Delete',
            isDestructive: true,
            onTap: () async {
              Navigator.of(context).pop();
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => DeleteConfirmationDialog(entry: entry),
              );
              if (confirm == true) {
                ref.read(journalListProvider.notifier).deleteEntry(entry.id);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({required IconData icon, required String title, required VoidCallback onTap, bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent : Colors.white;
    return ListTile(
      leading: Icon(icon, color: color, size: 26),
      title: Text(title, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}
