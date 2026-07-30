import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:kaizen/features/gym/data/daos/workout_dao.dart';
import 'package:kaizen/features/gym/data/daos/exercise_dao.dart';

part 'gym_database.g.dart';

// --- ENUMS & CONVERTERS ---

enum MuscleGroup {
  chest, shoulders, triceps, back, biceps, abs, glutes, calves,
  forearms, quads, hamstrings, adductors, abductors,
  tibialisAnterior, obliques,
}

enum OneRmFormula { epley, brzycki, lander, oconnor, average }

enum SetLabel { warmUp, amrap, pr, failure, none }

enum MultisetTemplate { superset, dropset, checkmark, custom }

enum GymWeightUnit { kg, lb }

class MuscleGroupListConverter extends TypeConverter<List<MuscleGroup>, String> {
  const MuscleGroupListConverter();

  @override
  List<MuscleGroup> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    return fromDb.split(',').map((e) => MuscleGroup.values.byName(e)).toList();
  }

  @override
  String toSql(List<MuscleGroup> value) {
    return value.map((e) => e.name).join(',');
  }
}

// --- TABLES ---

@DataClassName('Exercise')
class Exercises extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  TextColumn get primaryMuscles => text().map(const MuscleGroupListConverter())();
  TextColumn get secondaryMuscles => text().map(const MuscleGroupListConverter())();
  IntColumn get defaultFormulaIndex => integer().withDefault(Constant(OneRmFormula.average.index))();
  BoolColumn get oneRmEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('SetEntry')
class SetEntries extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get exerciseId => text().references(Exercises, #id, onDelete: KeyAction.cascade)();
  TextColumn get workoutSessionId => text().nullable()();
  TextColumn get multisetId => text().nullable()();
  RealColumn get weightKg => real()();
  IntColumn get reps => integer()();
  IntColumn get labelIndex => integer().withDefault(Constant(SetLabel.none.index))();
  DateTimeColumn get performedAt => dateTime().clientDefault(() => DateTime.now())();
  TextColumn get note => text().nullable()();
  IntColumn get restSecondsBefore => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Workout')
class Workouts extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get groupId => text().nullable()();
  IntColumn get sortIndex => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutStep')
class WorkoutSteps extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get workoutId => text().references(Workouts, #id, onDelete: KeyAction.cascade)();
  IntColumn get stepType => integer()(); // 0 = exercise, 1 = multiset
  TextColumn get refId => text()(); // exerciseId or multisetId
  IntColumn get stepOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('Multiset')
class Multisets extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  IntColumn get templateIndex => integer()();
  TextColumn get name => text().nullable()();
  IntColumn get sets => integer().withDefault(const Constant(1))();
  BoolColumn get restBetweenIsDefault => boolean().withDefault(const Constant(true))();
  IntColumn get restBetweenSeconds => integer().nullable()();
  BoolColumn get hasRestAfter => boolean().withDefault(const Constant(false))();
  IntColumn get restAfterSeconds => integer().nullable()();
  BoolColumn get checkOffEachSet => boolean().withDefault(const Constant(false))();
  IntColumn get iconIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('MultisetExerciseConfig')
class MultisetExerciseConfigs extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get multisetId => text().references(Multisets, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseId => text().references(Exercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutGroup')
class WorkoutGroups extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get colorIndex => integer().withDefault(const Constant(0))(); // 0..8

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('WorkoutSession')
class WorkoutSessions extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get workoutId => text().nullable().references(Workouts, #id, onDelete: KeyAction.setNull)();
  DateTimeColumn get date => dateTime().clientDefault(() => DateTime.now())();
  IntColumn get durationSeconds => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('BodyWeightEntry')
class BodyWeightEntries extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  DateTimeColumn get date => dateTime().clientDefault(() => DateTime.now())();
  RealColumn get weightKg => real()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('GymSetting')
class GymSettingsTable extends Table {
  TextColumn get id => text().withDefault(const Constant('default'))();
  IntColumn get unitIndex => integer().withDefault(Constant(GymWeightUnit.kg.index))();
  IntColumn get fullRecoveryDays => integer().withDefault(const Constant(3))();
  TextColumn get defaultPlateSet => text().withDefault(const Constant('2.5,5,10,25,45'))();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  Exercises,
  SetEntries,
  Workouts,
  WorkoutSteps,
  Multisets,
  MultisetExerciseConfigs,
  WorkoutGroups,
  WorkoutSessions,
  BodyWeightEntries,
  GymSettingsTable,
], daos: [WorkoutDao, ExerciseDao])
class GymDatabase extends _$GymDatabase {
  GymDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Insert default settings
      await into(gymSettingsTable).insert(
        GymSettingsTableCompanion.insert(),
        mode: InsertMode.insertOrIgnore,
      );
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kaizen_gym.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
