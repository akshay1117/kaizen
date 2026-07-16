import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/journal_entry.dart';
import '../../providers/journal_provider.dart';
import '../widgets/mood_chip.dart';

class CreateJournalScreen extends ConsumerStatefulWidget {
  const CreateJournalScreen({super.key});

  @override
  ConsumerState<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends ConsumerState<CreateJournalScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _tagsController = TextEditingController();
  final _locationController = TextEditingController();
  final _imageUrlController = TextEditingController();
  Mood _selectedMood = Mood.happy;
  bool _isFavorite = false;
  bool _showAddDetails = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _tagsController.dispose();
    _locationController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _saveEntry() {
    if (_titleController.text.isEmpty && _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title or body')),
      );
      return;
    }

    final tags = _tagsController.text
        .split(',')
        .map((t) => t.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    final images = _imageUrlController.text.isNotEmpty ? [_imageUrlController.text.trim()] : <String>[];

    final newEntry = JournalEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      body: _bodyController.text.trim(),
      images: images,
      mood: _selectedMood,
      location: _locationController.text.trim(),
      tags: tags,
      favorite: _isFavorite,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    ref.read(journalListProvider.notifier).addEntry(newEntry);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141415) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('New Journal', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border, color: _isFavorite ? Colors.redAccent : Colors.grey),
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
          ),
          TextButton(
            onPressed: _saveEntry,
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFF9b51e0), fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mood selector
              const Text('How are you feeling?', style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: Mood.values.map((mood) {
                    final isSelected = _selectedMood == mood;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMood = mood;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            border: isSelected ? Border.all(color: const Color(0xFF9b51e0), width: 2) : null,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: MoodChip(mood: mood),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),

              // Title input
              TextField(
                controller: _titleController,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 28, fontWeight: FontWeight.bold),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),

              // Body input (Expanded to increase writing area)
              Expanded(
                child: TextField(
                  controller: _bodyController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: const TextStyle(fontSize: 18, height: 1.5),
                  decoration: const InputDecoration(
                    hintText: 'Start writing...',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Collapsible Add Details Section
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _showAddDetails = !_showAddDetails;
                            });
                          },
                          icon: Icon(
                            _showAddDetails ? Icons.remove_circle_outline : Icons.add_circle_outline,
                            color: const Color(0xFF9b51e0),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _showAddDetails ? 'Hide Details' : 'Add Details',
                          style: const TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    if (_showAddDetails) ...[
                      const SizedBox(height: 12),
                      // Image URL
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
                        child: TextField(
                          controller: _imageUrlController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.image_outlined, color: Colors.grey),
                            hintText: 'Image URL (optional)',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Location
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
                        child: TextField(
                          controller: _locationController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.location_on_outlined, color: Colors.grey),
                            hintText: 'Location (optional)',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tags
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF2C2C2E), borderRadius: BorderRadius.circular(16)),
                        child: TextField(
                          controller: _tagsController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.tag, color: Colors.grey),
                            hintText: 'Tags (comma separated)',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
