import '../../domain/models/journal_entry.dart';
import '../../domain/repositories/journal_repository.dart';
import '../datasource/journal_local_datasource.dart';

class JournalRepositoryImpl implements JournalRepository {
  final JournalLocalDatasource localDatasource;

  JournalRepositoryImpl({required this.localDatasource});

  @override
  Future<List<JournalEntry>> getEntries() {
    return localDatasource.getEntries();
  }

  @override
  Future<void> saveEntry(JournalEntry entry) {
    return localDatasource.saveEntry(entry);
  }

  @override
  Future<void> deleteEntry(String id) {
    return localDatasource.deleteEntry(id);
  }

  @override
  Future<void> clearAll() {
    return localDatasource.clearAll();
  }
}
