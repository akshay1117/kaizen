import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';
import 'package:drift/drift.dart' as drift;
import 'custom_color_picker.dart';

class AddCategoryBottomSheet extends ConsumerStatefulWidget {
  const AddCategoryBottomSheet({super.key});

  @override
  ConsumerState<AddCategoryBottomSheet> createState() => _AddCategoryBottomSheetState();
}

class _AddCategoryBottomSheetState extends ConsumerState<AddCategoryBottomSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iconController = TextEditingController();
  Color _selectedColor = const Color(0xFF0A84FF);
  bool _isIncome = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3C),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
                ),
                const Text(
                  'New Category',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty && _iconController.text.isNotEmpty) {
                      final dao = ref.read(expenseDaoProvider);
                      await dao.insertCategory(
                        ExpenseCategoriesCompanion.insert(
                          name: _nameController.text,
                          icon: _iconController.text,
                          colorHex: _selectedColor.toARGB32().toRadixString(16).padLeft(8, '0'),
                          isIncome: drift.Value(_isIncome),
                        ),
                      );
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('Save', style: TextStyle(color: Color(0xFF0A84FF), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF2C2C2E), height: 1),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Icon Input
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: _selectedColor, width: 2),
                        ),
                        alignment: Alignment.center,
                        child: TextField(
                          controller: _iconController,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 32),
                          maxLength: 2,
                          decoration: const InputDecoration(
                            counterText: "",
                            border: InputBorder.none,
                            hintText: "🎨",
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Name Input
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Category Name',
                            hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                            filled: true,
                            fillColor: const Color(0xFF1C1C1E),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Type Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Category Type', style: TextStyle(color: Colors.white, fontSize: 16)),
                      Row(
                        children: [
                          const Text('Expense', style: TextStyle(color: Color(0xFF8E8E93))),
                          Switch(
                            value: _isIncome,
                            onChanged: (val) => setState(() => _isIncome = val),
                            activeTrackColor: const Color(0xFF34C759),
                          ),
                          const Text('Income', style: TextStyle(color: Color(0xFF8E8E93))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Color Picker
                  const Text('Color', style: TextStyle(color: Colors.white, fontSize: 16)),
                  const SizedBox(height: 16),
                  CustomColorPicker(
                    initialColor: _selectedColor,
                    onColorChanged: (color) {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
