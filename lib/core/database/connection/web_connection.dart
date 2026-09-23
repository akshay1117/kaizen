import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

LazyDatabase openConnection(String dbName, [String? userId]) {
  return LazyDatabase(() async {
    final suffix = (userId != null && userId.isNotEmpty) ? '_$userId' : '';
    final result = await WasmDatabase.open(
      databaseName: '$dbName$suffix',
      sqlite3Uri: Uri.parse('sqlite3.wasm'),
      driftWorkerUri: Uri.parse('drift_worker.dart.js'),
    );
    return result.resolvedExecutor;
  });
}
