import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/journal_entry.dart';
import '../domain/repositories/journal_repository.dart';
import '../data/datasource/journal_local_datasource.dart';
import '../data/repositories/journal_repository_impl.dart';

final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepositoryImpl(localDatasource: HiveJournalLocalDatasource());
});

class JournalFilterState {
  final String searchQuery;
  final String sortBy; // 'date' or 'title'
  final bool favoritesOnly;

  const JournalFilterState({
    this.searchQuery = '',
    this.sortBy = 'date',
    this.favoritesOnly = false,
  });

  JournalFilterState copyWith({
    String? searchQuery,
    String? sortBy,
    bool? favoritesOnly,
  }) {
    return JournalFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      favoritesOnly: favoritesOnly ?? this.favoritesOnly,
    );
  }
}

final journalFilterProvider = StateNotifierProvider<JournalFilterNotifier, JournalFilterState>((ref) {
  return JournalFilterNotifier();
});

class JournalFilterNotifier extends StateNotifier<JournalFilterState> {
  JournalFilterNotifier() : super(const JournalFilterState());

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
  }

  void toggleFavoritesOnly() {
    state = state.copyWith(favoritesOnly: !state.favoritesOnly);
  }
}

final journalListProvider = StateNotifierProvider<JournalListNotifier, AsyncValue<List<JournalEntry>>>((ref) {
  final repository = ref.watch(journalRepositoryProvider);
  return JournalListNotifier(repository);
});

class JournalListNotifier extends StateNotifier<AsyncValue<List<JournalEntry>>> {
  final JournalRepository repository;

  JournalListNotifier(this.repository) : super(const AsyncValue.loading()) {
    loadEntries();
  }

  Future<void> loadEntries() async {
    state = const AsyncValue.loading();
    try {
      final entries = await repository.getEntries();
      state = AsyncValue.data(entries);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addEntry(JournalEntry entry) async {
    await repository.saveEntry(entry);
    await loadEntries();
  }

  Future<void> updateEntry(JournalEntry entry) async {
    await repository.saveEntry(entry);
    await loadEntries();
  }

  Future<void> toggleFavorite(String id) async {
    final currentEntries = state.value ?? [];
    final index = currentEntries.indexWhere((e) => e.id == id);
    if (index != -1) {
      final updated = currentEntries[index].copyWith(favorite: !currentEntries[index].favorite);
      await repository.saveEntry(updated);
      await loadEntries();
    }
  }

  Future<void> deleteEntry(String id) async {
    await repository.deleteEntry(id);
    await loadEntries();
  }

  Future<void> clearAll() async {
    await repository.clearAll();
    await loadEntries();
  }
}

final filteredJournalListProvider = Provider<List<JournalEntry>>((ref) {
  final entriesState = ref.watch(journalListProvider);
  final filterState = ref.watch(journalFilterProvider);

  final entries = entriesState.value ?? [];
  var result = List<JournalEntry>.from(entries);

  // Filter favorites
  if (filterState.favoritesOnly) {
    result = result.where((e) => e.favorite).toList();
  }

  // Filter by search query (instant real-time filtering on title, body, tags, mood, location)
  if (filterState.searchQuery.isNotEmpty) {
    final query = filterState.searchQuery.toLowerCase();
    result = result.where((e) {
      final titleMatch = e.title.toLowerCase().contains(query);
      final bodyMatch = e.body.toLowerCase().contains(query);
      final locationMatch = (e.location ?? '').toLowerCase().contains(query);
      final moodMatch = e.mood.displayName.toLowerCase().contains(query);
      final tagsMatch = e.tags.any((t) => t.toLowerCase().contains(query));
      return titleMatch || bodyMatch || locationMatch || moodMatch || tagsMatch;
    }).toList();
  }

  // Sort
  if (filterState.sortBy == 'title') {
    result.sort((a, b) => a.title.compareTo(b.title));
  } else {
    // default date sort (newest first)
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  return result;
});
