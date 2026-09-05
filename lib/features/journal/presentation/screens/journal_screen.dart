import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/journal_provider.dart';
import '../widgets/journal_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/floating_create_button.dart';
import '../widgets/search_bar.dart';
import 'package:kaizen/core/widgets/streak_badge.dart';

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

    return GlassScaffold(
      backgroundColor: isDark ? const Color(0xFF141415) : Colors.grey[100],
      body: Stack(
        children: [
          RefreshIndicator(
            color: AppColors.accentViolet,
            backgroundColor: AppColors.surfaceElevatedHigh,
            onRefresh: () async {
              await ref.read(journalListProvider.notifier).loadEntries();
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverAppBar.large(
                  backgroundColor: isDark ? const Color(0xFF141415) : Colors.grey[100],

                  centerTitle: false,
                  title: const Text(
                    'Journal',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                      child: StreakBadge(
                        streak: 2,
                        icon: Icons.edit_note,
                        iconColor: AppColors.textPrimary,
                      ),
                    ),
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
                      color: AppColors.surfaceElevatedHigh,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.lg)),
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
                              backgroundColor: AppColors.surfaceElevatedHigh,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                              title: const Text('Delete All Entries', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                              content: const Text('Are you sure you want to delete all journal entries? This cannot be undone.', style: TextStyle(color: Colors.grey)),
                              actions: [
                                TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
                                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete All', style: TextStyle(color: AppColors.semanticUrgent, fontWeight: FontWeight.bold))),
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
                              Icon(Icons.calendar_today, color: filterState.sortBy == 'date' ? AppColors.accentViolet : AppColors.textPrimary, size: 20),
                              const SizedBox(width: 12),
                              Text('Sort by Date', style: TextStyle(color: filterState.sortBy == 'date' ? AppColors.accentViolet : AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'title',
                          child: Row(
                            children: [
                              Icon(Icons.sort_by_alpha, color: filterState.sortBy == 'title' ? AppColors.accentViolet : AppColors.textPrimary, size: 20),
                              const SizedBox(width: 12),
                              Text('Sort by Title', style: TextStyle(color: filterState.sortBy == 'title' ? AppColors.accentViolet : AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'favorites',
                          child: Row(
                            children: [
                              Icon(filterState.favoritesOnly ? Icons.favorite : Icons.favorite_border, color: filterState.favoritesOnly ? AppColors.semanticUrgent : AppColors.textPrimary, size: 20),
                              const SizedBox(width: 12),
                              Text('Favorites Only', style: TextStyle(color: filterState.favoritesOnly ? AppColors.semanticUrgent : AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete_all',
                          child: Row(
                            children: [
                              Icon(Icons.delete_sweep, color: AppColors.semanticUrgent, size: 20),
                              SizedBox(width: 12),
                              Text('Delete All', style: TextStyle(color: AppColors.semanticUrgent)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'settings',
                          child: Row(
                            children: [
                              Icon(Icons.settings_outlined, color: AppColors.textPrimary, size: 20),
                              SizedBox(width: 12),
                              Text('Settings', style: TextStyle(color: AppColors.textPrimary)),
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
                entries.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const SliverFillRemaining(
                        child: EmptyStateWidget(),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final entry = data[index];
                            return JournalCard(entry: entry);
                          },
                          childCount: data.length,
                        ),
                      ),
                    );
                  },
                  loading: () => const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: AppColors.accentViolet)),
                  ),
                  error: (err, stack) => const SliverFillRemaining(
                    child: Center(child: Text('Error loading entries', style: TextStyle(color: AppColors.semanticUrgent))),
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: FloatingCreateButton(),
          ),
        ],
      ),
    );
  }
}
