import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';

class JournalRepositoryImpl implements JournalRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  String get _userId => _supabase.auth.currentUser!.id;

  @override
  Future<List<JournalEntry>> getEntries() async {
    final data = await _supabase
        .from('journal_entries')
        .select()
        .eq('user_id', _userId)
        .order('created_at', ascending: false);

    return data.map((json) {
      // Map Supabase snake_case to the camelCase expected by JournalEntry.fromJson
      return JournalEntry.fromJson({
        'id': json['id'],
        'title': json['title'],
        'body': json['body'],
        'images': json['images'],
        'audioPath': json['audio_path'],
        'mood': json['mood'],
        'prompt': json['prompt'],
        'location': json['location'],
        'tags': json['tags'],
        'favorite': json['favorite'],
        'createdAt': json['created_at'],
        'updatedAt': json['updated_at'],
      });
    }).toList();
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    final payload = {
      'id': entry.id,
      'user_id': _userId,
      'title': entry.title,
      'body': entry.body,
      'images': entry.images,
      'audio_path': entry.audioPath,
      'mood': entry.mood.name,
      'prompt': entry.prompt,
      'location': entry.location,
      'tags': entry.tags,
      'favorite': entry.favorite,
      'created_at': entry.createdAt.toIso8601String(),
      'updated_at': entry.updatedAt.toIso8601String(),
    };

    // Upsert since saveEntry handles both create and update
    await _supabase.from('journal_entries').upsert(payload);
  }

  @override
  Future<void> deleteEntry(String id) async {
    await _supabase.from('journal_entries').delete().eq('id', id);
  }

  @override
  Future<void> clearAll() async {
    await _supabase.from('journal_entries').delete().eq('user_id', _userId);
  }
}
