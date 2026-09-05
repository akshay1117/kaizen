import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// Tables
@DataClassName('Habit')
class Habits extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get color => text()(); // hex
  TextColumn get frequency => text()(); // daily, weekly
  TextColumn get reminderTime => text().nullable()(); // "HH:mm"
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  BoolColumn get isQuantitative => boolean().withDefault(const Constant(false))();
  IntColumn get targetValue => integer().withDefault(const Constant(1))();
  TextColumn get unit => text().nullable()();
  TextColumn get categories => text().nullable()(); // comma-separated
  TextColumn get streakGoalInterval => text().withDefault(const Constant('none'))(); // none, daily, weekly, monthly
  DateTimeColumn get archivedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

@DataClassName('HabitLog')
class HabitLogs extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get habitId => text().references(Habits, #id)();
  DateTimeColumn get completedDate => dateTime()(); // stores only the date part
  IntColumn get progress => integer().withDefault(const Constant(1))();
  TextColumn get note => text().nullable()();
}

@DataClassName('JournalEntry')
class JournalEntries extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get content => text()();
  IntColumn get mood => integer()(); // 1-5
  TextColumn get moduleRef => text().nullable()(); // gym, boxing, etc.
  TextColumn get refId => text().nullable()(); // FK to specific workout/run
  DateTimeColumn get entryDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
}

@DriftDatabase(tables: [Habits, HabitLogs, JournalEntries])
class AppDatabase extends _$AppDatabase {
  AppDatabase([String? userId]) : super(_openConnection(userId));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(habits, habits.isQuantitative);
            await m.addColumn(habits, habits.targetValue);
            await m.addColumn(habits, habits.unit);
            await m.addColumn(habitLogs, habitLogs.progress);
          }
          if (from < 3) {
            await m.addColumn(habits, habits.categories);
            await m.addColumn(habits, habits.streakGoalInterval);
          }
        },
      );
}

LazyDatabase _openConnection([String? userId]) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final suffix = (userId != null && userId.isNotEmpty) ? '_$userId' : '';
    final file = File(p.join(dbFolder.path, 'kaizen$suffix.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}