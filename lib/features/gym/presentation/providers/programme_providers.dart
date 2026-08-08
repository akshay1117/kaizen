import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/presentation/providers/gym_providers.dart';

final allProgrammesProvider = StreamProvider<List<Programme>>((ref) {
  final dao = ref.watch(programmeDaoProvider);
  return dao.watchAllProgrammes();
});

final programmeWorkoutsProvider = StreamProvider.family<List<ProgrammeWorkout>, String>((ref, programmeId) {
  final dao = ref.watch(programmeDaoProvider);
  return dao.watchWorkoutsForProgramme(programmeId);
});
