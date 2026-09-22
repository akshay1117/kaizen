import 'package:drift/drift.dart';

LazyDatabase openConnection(String dbName, [String? userId]) {
  throw UnsupportedError('No suitable database implementation was found on this platform.');
}
