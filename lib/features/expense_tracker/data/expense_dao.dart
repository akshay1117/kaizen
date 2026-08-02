import 'package:drift/drift.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';

part 'expense_dao.g.dart';

class TransactionWithDetails {
  final ExpenseTransaction transaction;
  final ExpenseCategory category;
  final ExpenseAccount? account;

  TransactionWithDetails({
    required this.transaction,
    required this.category,
    this.account,
  });
}

@DriftAccessor(tables: [
  ExpenseTrackers, 
  ExpenseMembers, 
  ExpenseAccounts, 
  ExpenseCategories, 
  ExpenseSubscriptions,
  ExpenseInstallments,
  ExpenseTransactions
])
class ExpenseDao extends DatabaseAccessor<ExpenseDatabase> with _$ExpenseDaoMixin {
  ExpenseDao(super.db);

  // Trackers
  Future<List<ExpenseTracker>> getAllTrackers() => select(expenseTrackers).get();
  Stream<List<ExpenseTracker>> watchAllTrackers() => select(expenseTrackers).watch();
  Future<int> insertTracker(ExpenseTrackersCompanion tracker) => into(expenseTrackers).insert(tracker);
  Future<bool> updateTracker(ExpenseTracker tracker) => update(expenseTrackers).replace(tracker);
  Future<int> deleteTracker(ExpenseTracker tracker) => delete(expenseTrackers).delete(tracker);

  // Members
  Future<List<ExpenseMember>> getMembersForTracker(String trackerId) {
    return (select(expenseMembers)..where((m) => m.trackerId.equals(trackerId))).get();
  }
  Stream<List<ExpenseMember>> watchMembersForTracker(String trackerId) {
    return (select(expenseMembers)..where((m) => m.trackerId.equals(trackerId))).watch();
  }
  Future<int> insertMember(ExpenseMembersCompanion member) => into(expenseMembers).insert(member);
  Future<bool> updateMember(ExpenseMember member) => update(expenseMembers).replace(member);
  Future<int> deleteMember(ExpenseMember member) => delete(expenseMembers).delete(member);

  // Accounts
  Future<List<ExpenseAccount>> getAllAccounts() => select(expenseAccounts).get();
  Stream<List<ExpenseAccount>> watchAllAccounts() => select(expenseAccounts).watch();
  Future<int> insertAccount(ExpenseAccountsCompanion account) => into(expenseAccounts).insert(account);
  Future<bool> updateAccount(ExpenseAccount account) => update(expenseAccounts).replace(account);
  Future<int> deleteAccount(ExpenseAccount account) => delete(expenseAccounts).delete(account);

  // Categories
  Future<List<ExpenseCategory>> getAllCategories() => select(expenseCategories).get();
  Stream<List<ExpenseCategory>> watchAllCategories() => select(expenseCategories).watch();
  Stream<List<ExpenseCategory>> watchCategoriesByType(bool isIncome) {
    return (select(expenseCategories)..where((c) => c.isIncome.equals(isIncome))).watch();
  }
  Future<int> insertCategory(ExpenseCategoriesCompanion category) => into(expenseCategories).insert(category);
  Future<bool> updateCategory(ExpenseCategory category) => update(expenseCategories).replace(category);
  Future<int> deleteCategory(ExpenseCategory category) => delete(expenseCategories).delete(category);

  // Transactions
  Stream<List<ExpenseTransaction>> watchAllTransactions() {
    return (select(expenseTransactions)
      ..orderBy([(t) => OrderingTerm(expression: t.date, mode: OrderingMode.desc)])
    ).watch();
  }
  
  Stream<List<TransactionWithDetails>> watchTransactionsWithDetailsByMonth(DateTime month, {String? trackerId}) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1).subtract(const Duration(milliseconds: 1));
    return watchTransactionsWithDetailsByPeriod(start, end, trackerId: trackerId);
  }

  Stream<List<TransactionWithDetails>> watchTransactionsWithDetailsByPeriod(DateTime start, DateTime end, {String? trackerId}) {
    final query = select(expenseTransactions).join([
      innerJoin(expenseCategories, expenseCategories.id.equalsExp(expenseTransactions.categoryId)),
      leftOuterJoin(expenseAccounts, expenseAccounts.id.equalsExp(expenseTransactions.accountId)),
    ])..where(expenseTransactions.date.isBetweenValues(start, end));

    if (trackerId != null) {
      query.where(expenseTransactions.trackerId.equals(trackerId));
    }

    query.orderBy([OrderingTerm(expression: expenseTransactions.date, mode: OrderingMode.desc)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithDetails(
          transaction: row.readTable(expenseTransactions),
          category: row.readTable(expenseCategories),
          account: row.readTableOrNull(expenseAccounts),
        );
      }).toList();
    });
  }

  Future<List<TransactionWithDetails>> getAllTransactionsWithDetails() async {
    final query = select(expenseTransactions).join([
      innerJoin(expenseCategories, expenseCategories.id.equalsExp(expenseTransactions.categoryId)),
      leftOuterJoin(expenseAccounts, expenseAccounts.id.equalsExp(expenseTransactions.accountId)),
    ])..orderBy([OrderingTerm(expression: expenseTransactions.date, mode: OrderingMode.desc)]);

    final rows = await query.get();
    return rows.map((row) {
      return TransactionWithDetails(
        transaction: row.readTable(expenseTransactions),
        category: row.readTable(expenseCategories),
        account: row.readTableOrNull(expenseAccounts),
      );
    }).toList();
  }

  Future<int> insertTransaction(ExpenseTransactionsCompanion transaction) => into(expenseTransactions).insert(transaction);
  Future<bool> updateTransaction(ExpenseTransaction transaction) => update(expenseTransactions).replace(transaction);
  Future<int> deleteTransaction(ExpenseTransaction transaction) => delete(expenseTransactions).delete(transaction);

  // Subscriptions
  Stream<List<ExpenseSubscription>> watchAllSubscriptions() => select(expenseSubscriptions).watch();
  Future<int> insertSubscription(ExpenseSubscriptionsCompanion sub) => into(expenseSubscriptions).insert(sub);
  Future<bool> updateSubscription(ExpenseSubscription sub) => update(expenseSubscriptions).replace(sub);
  Future<int> deleteSubscription(ExpenseSubscription sub) => delete(expenseSubscriptions).delete(sub);

  // Installments
  Stream<List<ExpenseInstallment>> watchAllInstallments() => select(expenseInstallments).watch();
  Future<int> insertInstallment(ExpenseInstallmentsCompanion inst) => into(expenseInstallments).insert(inst);
  Future<bool> updateInstallment(ExpenseInstallment inst) => update(expenseInstallments).replace(inst);
  Future<int> deleteInstallment(ExpenseInstallment inst) => delete(expenseInstallments).delete(inst);
}
