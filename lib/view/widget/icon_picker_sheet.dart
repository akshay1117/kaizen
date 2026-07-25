import 'package:flutter/material.dart';
import 'package:kaizen/utils/habit_icons.dart';

Future<String?> showIconPicker(BuildContext context, {String? currentSelection}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => IconPickerSheet(currentSelection: currentSelection),
  );
}

class IconPickerSheet extends StatefulWidget {
  final String? currentSelection;

  const IconPickerSheet({super.key, this.currentSelection});

  @override
  State<IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<IconPickerSheet> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            // Can be used to trigger layout changes if needed based on extent
            return false;
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF111111), // Dark background matching spec
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Drag Handle
                const SizedBox(height: 12),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Header (changes style if needed, but keeping it simple for now)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const Text(
                            'Pick Icon',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Select an icon for the category',
                            style: TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          
                          // Search Bar
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1A1A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Type a search term',
                                hintStyle: TextStyle(color: Colors.white38),
                                prefixIcon: Icon(Icons.search, color: Colors.white38),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                ),
                const SizedBox(height: 16),
                
                // Body
                Expanded(
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: _buildSlivers(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildSlivers() {
    if (_searchQuery.isNotEmpty) {
      // Flattened search results
      final List<MapEntry<String, IconData>> filtered = allHabitIcons.entries
          .where((entry) => entry.key.toLowerCase().contains(_searchQuery))
          .toList();
          
      return [
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildIconCell(filtered[index].key, filtered[index].value);
              },
              childCount: filtered.length,
            ),
          ),
        ),
      ];
    }

    // Grouped categories
    final List<Widget> slivers = [];
    
    for (var category in habitIconCategories) {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
            child: Text(
              category.name,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
      
      final entries = category.icons.entries.toList();
      
      slivers.add(
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildIconCell(entries[index].key, entries[index].value);
              },
              childCount: entries.length,
            ),
          ),
        ),
      );
    }
    
    // Bottom padding
    slivers.add(const SliverPadding(padding: EdgeInsets.only(bottom: 40)));
    
    return slivers;
  }

  Widget _buildIconCell(String id, IconData iconData) {
    final bool isSelected = id == widget.currentSelection;
    
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
        ),
        child: Icon(
          iconData,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
