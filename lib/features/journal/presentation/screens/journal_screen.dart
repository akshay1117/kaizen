import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/journal_provider.dart';
import '../widgets/journal_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/floating_create_button.dart';
import '../widgets/search_bar.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  bool _showSearch = false;

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(filteredJournalListProvider);
    final filterState = ref.watch(journalFilterProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF141415) : Colors.grey[100],
      floatingActionButton: const FloatingCreateButton(),
      body: RefreshIndicator(
        color: const Color(0xFF9b51e0),
        backgroundColor: const Color(0xFF2C2C2E),
        onRefresh: () async {
          await ref.read(journalListProvider.notifier).loadEntries();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverAppBar.large(
              backgroundColor: isDark ? const Color(0xFF141415) : Colors.grey[100],
              elevation: 0,
              centerTitle: false,
              title: const Text(
                'Journal',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                  icon: Icon(_showSearch ? Icons.search_off : Icons.search, size: 26),
                  onPressed: () {
                    setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        ref.read(journalFilterProvider.notifier).updateSearchQuery('');
                      }
                    });
                  },
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 26),
                  color: const Color(0xFF2C2C2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  onSelected: (value) async {
                    final notifier = ref.read(journalFilterProvider.notifier);
                    final listNotifier = ref.read(journalListProvider.notifier);
                    if (value == 'date') {
                      notifier.updateSortBy('date');
                    } else if (value == 'title') {
                      notifier.updateSortBy('title');
                    } else if (value == 'favorites') {
                      notifier.toggleFavoritesOnly();
                    } else if (value == 'delete_all') {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF2C2C2E),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                          title: const Text('Delete All Entries', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          content: const Text('Are you sure you want to delete all journal entries? This cannot be undone.', style: TextStyle(color: Colors.grey)),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                            TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete All', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))),
                          ],
                        ),
                      );
                      if (confirm == true) {
                        listNotifier.clearAll();
                      }
                    } else if (value == 'settings') {
                      // navigate to settings if needed
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'date',
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, color: filterState.sortBy == 'date' ? const Color(0xFF9b51e0) : Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text('Sort by Date', style: TextStyle(color: filterState.sortBy == 'date' ? const Color(0xFF9b51e0) : Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'title',
                      child: Row(
                        children: [
                          Icon(Icons.sort_by_alpha, color: filterState.sortBy == 'title' ? const Color(0xFF9b51e0) : Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text('Sort by Title', style: TextStyle(color: filterState.sortBy == 'title' ? const Color(0xFF9b51e0) : Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'favorites',
                      child: Row(
                        children: [
                          Icon(filterState.favoritesOnly ? Icons.favorite : Icons.favorite_border, color: filterState.favoritesOnly ? Colors.redAccent : Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Text('Favorites Only', style: TextStyle(color: filterState.favoritesOnly ? Colors.redAccent : Colors.white)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete_all',
                      child: Row(
                        children: [
                          Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20),
                          SizedBox(width: 12),
                          Text('Delete All', style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings_outlined, color: Colors.white, size: 20),
                          SizedBox(width: 12),
                          Text('Settings', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (_showSearch)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: JournalSearchBar(),
                ),
              ),
            if (entries.isEmpty)
              const SliverFillRemaining(
                child: EmptyStateWidget(),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = entries[index];
                      return JournalCard(entry: entry);
                    },
                    childCount: entries.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
