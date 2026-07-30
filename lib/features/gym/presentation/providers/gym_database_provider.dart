import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';

final gymDatabaseProvider = Provider<GymDatabase>((ref) {
  final db = GymDatabase();
  ref.onDispose(() => db.close());
  return db;
});

// Settings Provider
final gymSettingsProvider = StreamProvider<GymSetting>((ref) {
  final db = ref.watch(gymDatabaseProvider);
  return db.select(db.gymSettingsTable).watchSingle();
});
