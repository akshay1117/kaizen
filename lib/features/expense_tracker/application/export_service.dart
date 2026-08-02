import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../data/expense_dao.dart';

class ExpenseExportService {
  static Future<void> exportToCsv(List<TransactionWithDetails> transactions) async {
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add([
      'Date',
      'Category',
      'Account',
      'Amount',
      'Type',
      'Note'
    ]);

    for (var tx in transactions) {
      rows.add([
        DateFormat('yyyy-MM-dd').format(tx.transaction.date),
        tx.category.name,
        tx.account?.name ?? 'None',
        tx.transaction.amount,
        tx.transaction.isIncome ? 'Income' : 'Expense',
        tx.transaction.note ?? '',
      ]);
    }

    String csvData = csv.encode(rows);

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/expenses_export_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csvData);
    // ignore: deprecated_member_use
    await Share.shareXFiles([XFile(file.path)], text: 'Expense Export');
  }
}
