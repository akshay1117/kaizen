import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/journal_entry.dart';

abstract class JournalLocalDatasource {
  Future<List<JournalEntry>> getEntries();
  Future<void> saveEntry(JournalEntry entry);
  Future<void> deleteEntry(String id);
  Future<void> clearAll();
}

class HiveJournalLocalDatasource implements JournalLocalDatasource {
  final String userId;
  HiveJournalLocalDatasource({required this.userId});

  String get boxName => 'journal_box_v1_$userId';

  Future<Box<String>> _getBox() async {
    return await Hive.openBox<String>(boxName);
  }

  @override
  Future<List<JournalEntry>> getEntries() async {
    final box = await _getBox();
    if (box.isEmpty) {
      // Pre-populate with sample dummy journal entries as requested
      final dummyEntries = [
        JournalEntry(
          id: '1',
          title: 'Beach Day',
          body: 'Went to the beach today with my friends. The sunset was absolutely spectacular, painting the sky in shades of orange and purple. We played volleyball and had a great bonfire.',
          images: ['https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1000&auto=format&fit=crop'],
          mood: Mood.happy,
          location: 'Kochi, Kerala',
          tags: ['Travel', 'Friends'],
          favorite: true,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        JournalEntry(
          id: '2',
          title: 'Morning Reflection',
          body: 'Started the day with 30 minutes of deep meditation followed by a hot cup of green tea. Feeling incredibly grounded and ready to take on whatever challenges come my way today.',
          images: [],
          audioPath: 'sample_audio_reflection.aac',
          mood: Mood.calm,
          prompt: 'What made you smile today?',
          location: 'Home Studio',
          tags: ['Study', 'Fitness'],
          favorite: false,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        JournalEntry(
          id: '3',
          title: 'Project Milestone',
          body: 'Finally launched the new feature we have been working on for the past three months. The team celebrated with pizza and board games. Extremely proud of everyone.',
          images: ['https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=1000&auto=format&fit=crop'],
          mood: Mood.excited,
          location: 'Tech Park, Bangalore',
          tags: ['Work', 'Family'],
          favorite: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];

      for (final entry in dummyEntries) {
        await box.put(entry.id, jsonEncode(entry.toJson()));
      }
      return dummyEntries;
    }

    final entries = <JournalEntry>[];
    for (final key in box.keys) {
      final value = box.get(key);
      if (value != null) {
        try {
          entries.add(JournalEntry.fromJson(jsonDecode(value)));
        } catch (e) {
          // ignore corrupted entries
        }
      }
    }
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    final box = await _getBox();
    await box.put(entry.id, jsonEncode(entry.toJson()));
  }

  @override
  Future<void> deleteEntry(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  @override
  Future<void> clearAll() async {
    final box = await _getBox();
    await box.clear();
  }
}
