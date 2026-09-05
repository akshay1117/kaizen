import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/auth/presentation/providers/auth_provider.dart';

final gymDatabaseProvider = Provider<GymDatabase>((ref) {
  final user = ref.watch(currentUserProvider);
  final db = GymDatabase(user?.id);
  ref.onDispose(() => db.close());
  return db;
});

// Settings Provider
final gymSettingsProvider = StreamProvider<GymSetting>((ref) {
  final db = ref.watch(gymDatabaseProvider);
  return db.select(db.gymSettingsTable).watchSingle();
});
