import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:kaizen/features/expense_tracker/data/expense_dao.dart';

part 'expense_database.g.dart';

@DataClassName('ExpenseTracker')
class ExpenseTrackers extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  RealColumn get budget => real().nullable()();
  TextColumn get cycleType => text().withDefault(const Constant('Monthly'))(); // One-Time, Monthly
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseMember')
class ExpenseMembers extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get trackerId => text().references(ExpenseTrackers, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get avatarPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseAccount')
class ExpenseAccounts extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  TextColumn get icon => text().withDefault(const Constant('wallet'))();
  RealColumn get initialBalance => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseCategory')
class ExpenseCategories extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get name => text()();
  TextColumn get icon => text()();
  TextColumn get colorHex => text()();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseSubscription')
class ExpenseSubscriptions extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get trackerId => text().references(ExpenseTrackers, #id, onDelete: KeyAction.cascade)();
  TextColumn get accountId => text().nullable().references(ExpenseAccounts, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get interval => text().withDefault(const Constant('1 Month'))(); // e.g. 1 Month, 1 Year
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseInstallment')
class ExpenseInstallments extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get trackerId => text().references(ExpenseTrackers, #id, onDelete: KeyAction.cascade)();
  TextColumn get accountId => text().nullable().references(ExpenseAccounts, #id, onDelete: KeyAction.setNull)();
  TextColumn get name => text()();
  RealColumn get totalAmount => real()();
  RealColumn get installmentAmount => real()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('ExpenseTransaction')
class ExpenseTransactions extends Table {
  TextColumn get id => text().clientDefault(() => '${DateTime.now().millisecondsSinceEpoch}')();
  TextColumn get trackerId => text().nullable().references(ExpenseTrackers, #id, onDelete: KeyAction.cascade)();
  TextColumn get accountId => text().nullable().references(ExpenseAccounts, #id, onDelete: KeyAction.setNull)();
  TextColumn get categoryId => text().references(ExpenseCategories, #id, onDelete: KeyAction.cascade)();
  TextColumn get memberId => text().nullable().references(ExpenseMembers, #id, onDelete: KeyAction.setNull)();
  RealColumn get amount => real()();
  BoolColumn get isIncome => boolean().withDefault(const Constant(false))();
  DateTimeColumn get date => dateTime()();
  TextColumn get note => text().nullable()();
  TextColumn get attachments => text().nullable()(); // JSON list of paths
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  ExpenseTrackers,
  ExpenseMembers,
  ExpenseAccounts,
  ExpenseCategories,
  ExpenseSubscriptions,
  ExpenseInstallments,
  ExpenseTransactions,
], daos: [ExpenseDao])
class ExpenseDatabase extends _$ExpenseDatabase {
  ExpenseDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // Insert default categories
      await batch((batch) {
        batch.insertAll(expenseCategories, [
          ExpenseCategoriesCompanion.insert(
            id: const Value('cat_food'),
            name: 'Food',
            icon: 'utensils',
            colorHex: 'FFB020',
          ),
          ExpenseCategoriesCompanion.insert(
            id: const Value('cat_transport'),
            name: 'Transport',
            icon: 'car',
            colorHex: '2F86FF',
          ),
          ExpenseCategoriesCompanion.insert(
            id: const Value('cat_shopping'),
            name: 'Shopping',
            icon: 'shopping-bag',
            colorHex: 'B266FF',
          ),
          ExpenseCategoriesCompanion.insert(
            id: const Value('cat_salary'),
            name: 'Salary',
            icon: 'briefcase',
            colorHex: '20C997',
            isIncome: const Value(true),
          ),
        ]);
      });
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(expenseTrackers);
        await m.createTable(expenseMembers);
        await m.addColumn(expenseTransactions, expenseTransactions.trackerId);
        await m.addColumn(expenseTransactions, expenseTransactions.memberId);
      }
      if (from < 3) {
        await m.createTable(expenseSubscriptions);
        await m.createTable(expenseInstallments);
        await m.addColumn(expenseTransactions, expenseTransactions.attachments);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'kaizen_expense.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
