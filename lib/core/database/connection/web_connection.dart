import 'package:drift/drift.dart';
// ignore: deprecated_member_use
import 'package:drift/web.dart';

LazyDatabase openConnection(String dbName, [String? userId]) {
  return LazyDatabase(() async {
    final suffix = (userId != null && userId.isNotEmpty) ? '_$userId' : '';
    return WebDatabase.withStorage(await DriftWebStorage.indexedDbIfSupported('$dbName$suffix'));
  });
}
