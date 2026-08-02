import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';
import '../widgets/custom_color_picker.dart';

class AddCategoryModal extends ConsumerStatefulWidget {
  const AddCategoryModal({super.key});

  @override
  ConsumerState<AddCategoryModal> createState() => _AddCategoryModalState();
}

class _AddCategoryModalState extends ConsumerState<AddCategoryModal> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedEmoji = '🍔';
  Color _selectedColor = const Color(0xFFFF9500);

  final List<String> _emojis = [
    '🍔',
    '☕',
    '🚗',
    '🏠',
    '🎮',
    '✈️',
    '🛒',
    '💊',
    '📚',
    '👕',
    '📱',
    '💡'
  ];
  // Colors removed as they are now inside CustomColorPicker

  Future<void> _saveCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a category name.')));
      return;
    }

    final dao = ref.read(expenseDaoProvider);
    final colorHex =
        _selectedColor.toARGB32().toRadixString(16).padLeft(8, '0');

    await dao.insertCategory(
      ExpenseCategoriesCompanion.insert(
        name: name,
        icon: _selectedEmoji,
        colorHex: colorHex,
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const Text(
                  'New Category',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: _saveCategory,
                  child: const Text('Save',
                      style: TextStyle(
                          color: Color(0xFF0A84FF),
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF2C2C2E), height: 1),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Preview
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                        color: _selectedColor.withValues(alpha: 0.5), width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(_selectedEmoji,
                      style: const TextStyle(fontSize: 40)),
                ),
                const SizedBox(height: 24),

                // Name Input
                TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Category Name',
                    hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                    filled: true,
                    fillColor: const Color(0xFF1C1C1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Emoji Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Icon',
                      style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _emojis.length,
                    itemBuilder: (context, index) {
                      final emoji = _emojis[index];
                      final isSelected = _selectedEmoji == emoji;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedEmoji = emoji),
                        child: Container(
                          width: 50,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF2C2C2E)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child:
                              Text(emoji, style: const TextStyle(fontSize: 24)),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // Color Selection
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Color',
                      style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14)),
                ),
                const SizedBox(height: 8),
                CustomColorPicker(
                  initialColor: _selectedColor,
                  onColorChanged: (color) {
                    setState(() {
                      _selectedColor = color;
                    });
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
