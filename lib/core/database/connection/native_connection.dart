import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

LazyDatabase openConnection(String dbName, [String? userId]) {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final suffix = (userId != null && userId.isNotEmpty) ? '_$userId' : '';
    final file = File(p.join(dbFolder.path, '$dbName$suffix.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
