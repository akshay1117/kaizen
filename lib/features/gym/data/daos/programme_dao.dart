import 'package:kaizen/features/gym/data/gym_database.dart';

class ProgrammeDao {
  final GymDatabase db;
  ProgrammeDao(this.db);

  Stream<List<Programme>> watchAllProgrammes() {
    return db.select(db.programmes).watch();
  }

  Stream<List<ProgrammeWorkout>> watchWorkoutsForProgramme(String programmeId) {
    return (db.select(db.programmeWorkouts)..where((tbl) => tbl.programmeId.equals(programmeId))).watch();
  }

  Future<void> insertProgramme(ProgrammesCompanion programme) {
    return db.into(db.programmes).insert(programme);
  }

  Future<void> insertProgrammeWorkout(ProgrammeWorkoutsCompanion workout) {
    return db.into(db.programmeWorkouts).insert(workout);
  }

  Future<void> updateProgramme(ProgrammesCompanion programme) {
    return db.update(db.programmes).replace(programme);
  }

  Future<void> deleteProgramme(String id) {
    return (db.delete(db.programmes)..where((tbl) => tbl.id.equals(id))).go();
  }
}
