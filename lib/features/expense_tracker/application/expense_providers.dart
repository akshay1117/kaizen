import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';
import 'package:kaizen/features/expense_tracker/data/expense_dao.dart';
import 'package:kaizen/features/auth/presentation/providers/auth_provider.dart';

// Database Instance
final expenseDatabaseProvider = Provider<ExpenseDatabase>((ref) {
  final user = ref.watch(currentUserProvider);
  final db = ExpenseDatabase(user?.id);
  ref.onDispose(() => db.close());
  return db;
});

// DAO
final expenseDaoProvider = Provider<ExpenseDao>((ref) {
  final db = ref.watch(expenseDatabaseProvider);
  return db.expenseDao;
});

// Currency Formatter
final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  return NumberFormat.simpleCurrency(locale: 'en_IN');
});

// --- State Providers ---

// Current Month Selection
final selectedMonthProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month);
});

// Time Period Selection for Home Screen ('24H', '7D', '1M', '3M', '1Y', 'Custom')
final selectedTimePeriodProvider = StateProvider<String>((ref) => '1Y');

// Custom Date Range Selection
final customDateRangeProvider = StateProvider<({DateTime start, DateTime end})?>((ref) => null);

// Date Range Provider based on the selected time period
final timePeriodDateRangeProvider = Provider<({DateTime start, DateTime end})?>((ref) {
  final period = ref.watch(selectedTimePeriodProvider);
  final now = DateTime.now();
  final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  
  switch (period) {
    case '24H':
      return (start: now.subtract(const Duration(hours: 24)), end: endOfToday);
    case '7D':
      return (start: now.subtract(const Duration(days: 7)), end: endOfToday);
    case '1M':
      return (start: DateTime(now.year, now.month - 1, now.day), end: endOfToday);
    case '3M':
      return (start: DateTime(now.year, now.month - 3, now.day), end: endOfToday);
    case '1Y':
      return (start: DateTime(now.year - 1, now.month, now.day), end: endOfToday);
    case 'Custom':
      final customRange = ref.watch(customDateRangeProvider);
      if (customRange != null) {
        return customRange;
      }
      return (start: now.subtract(const Duration(days: 30)), end: endOfToday);
    default:
      return (start: DateTime(now.year - 1, now.month, now.day), end: endOfToday);
  }
});

// Filter Options
class ExpenseFilterOptions {
  final bool installmentsOnly;
  final bool subscriptionsOnly;
  final String sortBy; // 'Date', 'Name', 'Amount', 'Category'

  ExpenseFilterOptions({
    this.installmentsOnly = false,
    this.subscriptionsOnly = false,
    this.sortBy = 'Date',
  });

  ExpenseFilterOptions copyWith({
    bool? installmentsOnly,
    bool? subscriptionsOnly,
    String? sortBy,
  }) {
    return ExpenseFilterOptions(
      installmentsOnly: installmentsOnly ?? this.installmentsOnly,
      subscriptionsOnly: subscriptionsOnly ?? this.subscriptionsOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

final expenseFilterProvider = StateProvider<ExpenseFilterOptions>((ref) => ExpenseFilterOptions());


final filteredTransactionsProvider = StreamProvider<List<TransactionWithDetails>>((ref) async* {
  final dao = ref.watch(expenseDaoProvider);
  final dateRange = ref.watch(timePeriodDateRangeProvider);
  final filters = ref.watch(expenseFilterProvider);
  final currentTrackerAsync = ref.watch(currentTrackerProvider);
  final trackerId = currentTrackerAsync.value?.id;
  
  if (dateRange == null || trackerId == null) {
    yield [];
    return;
  }
  
  final stream = dao.watchTransactionsWithDetailsByPeriod(dateRange.start, dateRange.end, trackerId: trackerId);
  
  await for (final transactions in stream) {
    var filtered = List<TransactionWithDetails>.from(transactions);
    
    // Sort
    if (filters.sortBy == 'Amount') {
      filtered.sort((a, b) => b.transaction.amount.compareTo(a.transaction.amount));
    } else if (filters.sortBy == 'Name') {
      filtered.sort((a, b) => (a.transaction.note ?? a.category.name).compareTo(b.transaction.note ?? b.category.name));
    } else if (filters.sortBy == 'Category') {
      filtered.sort((a, b) => a.category.name.compareTo(b.category.name));
    } else { // Date
      filtered.sort((a, b) => b.transaction.date.compareTo(a.transaction.date));
    }
    
    yield filtered;
  }
});

// Stream of Categories
final categoriesProvider = StreamProvider<List<ExpenseCategory>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  return dao.watchAllCategories();
});

// Stream of Accounts
final accountsProvider = StreamProvider<List<ExpenseAccount>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  return dao.watchAllAccounts();
});

// Stream of Trackers
final trackersProvider = StreamProvider<List<ExpenseTracker>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  return dao.watchAllTrackers();
});

// Stream of Subscriptions
final subscriptionsProvider = StreamProvider<List<ExpenseSubscription>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  return dao.watchAllSubscriptions();
});

// Stream of Installments
final installmentsProvider = StreamProvider<List<ExpenseInstallment>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  return dao.watchAllInstallments();
});

// Current Active Tracker Selection
final selectedTrackerIdProvider = StateProvider<String?>((ref) => null);

// Current Tracker Object
final currentTrackerProvider = Provider<AsyncValue<ExpenseTracker?>>((ref) {
  final trackersAsync = ref.watch(trackersProvider);
  final selectedId = ref.watch(selectedTrackerIdProvider);
  
  return trackersAsync.whenData((trackers) {
    if (trackers.isEmpty) return null;
    if (selectedId == null) return trackers.first;
    
    // Return the selected tracker, or fallback to the first one if not found
    try {
      return trackers.firstWhere((t) => t.id == selectedId);
    } catch (e) {
      return trackers.first;
    }
  });
});

// Stream of Members for the selected tracker
final membersForSelectedTrackerProvider = StreamProvider<List<ExpenseMember>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  final trackerId = ref.watch(selectedTrackerIdProvider);
  if (trackerId == null) return Stream.value([]);
  return dao.watchMembersForTracker(trackerId);
});

// Stream of Transactions with details for the selected month
final transactionsForMonthProvider = StreamProvider<List<TransactionWithDetails>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  final month = ref.watch(selectedMonthProvider);
  final trackerId = ref.watch(selectedTrackerIdProvider);
  return dao.watchTransactionsWithDetailsByMonth(month, trackerId: trackerId);
});

// --- Analytics Specific Providers ---

// Time Period Selection for Analytics Screen
// Mapping: '24H', '7D', '1M', '3M', '1Y', 'Custom'
final analyticsTimePeriodProvider = StateProvider<String>((ref) => '1M');

final analyticsCustomDateRangeProvider = StateProvider<({DateTime start, DateTime end})?>((ref) => null);

final analyticsDateRangeProvider = Provider<({DateTime start, DateTime end})?>((ref) {
  final period = ref.watch(analyticsTimePeriodProvider);
  final now = DateTime.now();
  final endOfToday = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
  
  switch (period) {
    case '24H':
      return (start: now.subtract(const Duration(hours: 24)), end: endOfToday);
    case '7D':
      return (start: now.subtract(const Duration(days: 7)), end: endOfToday);
    case '1M':
      return (start: DateTime(now.year, now.month - 1, now.day), end: endOfToday);
    case '3M':
      return (start: DateTime(now.year, now.month - 3, now.day), end: endOfToday);
    case '1Y':
      return (start: DateTime(now.year - 1, now.month, now.day), end: endOfToday);
    case 'Custom':
      final customRange = ref.watch(analyticsCustomDateRangeProvider);
      if (customRange != null) {
        return customRange;
      }
      return (start: now.subtract(const Duration(days: 30)), end: endOfToday);
    default:
      return (start: DateTime(now.year, now.month - 1, now.day), end: endOfToday);
  }
});

final analyticsTransactionsProvider = StreamProvider<List<TransactionWithDetails>>((ref) {
  final dao = ref.watch(expenseDaoProvider);
  final dateRange = ref.watch(analyticsDateRangeProvider);
  final currentTrackerAsync = ref.watch(currentTrackerProvider);
  final trackerId = currentTrackerAsync.value?.id;
  
  if (dateRange == null || trackerId == null) {
    return Stream.value([]);
  }
  
  return dao.watchTransactionsWithDetailsByPeriod(dateRange.start, dateRange.end, trackerId: trackerId);
});

// Derived Providers for Dashboard / Balance Card
class BalanceData {
  final double totalBalance;
  final double income;
  final double expense;

  BalanceData({
    required this.totalBalance,
    required this.income,
    required this.expense,
  });
}

final balanceDataProvider = Provider<AsyncValue<BalanceData>>((ref) {
  final transactionsAsync = ref.watch(transactionsForMonthProvider);
  
  return transactionsAsync.whenData((transactions) {
    double income = 0;
    double expense = 0;
    
    for (var t in transactions) {
      if (t.transaction.isIncome) {
        income += t.transaction.amount;
      } else {
        expense += t.transaction.amount;
      }
    }
    
    return BalanceData(
      totalBalance: income - expense, // For the month, or maybe total across all time? Cashify usually shows total account balance. But this is simple for now.
      income: income,
      expense: expense,
    );
  });
});
