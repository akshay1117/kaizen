import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';

class CustomCategoriesModal extends ConsumerWidget {
  const CustomCategoriesModal({super.key});

  void _showNewCategorySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: const NewCategorySheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfacePitchBlack,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Custom Categories',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.accentViolet),
                    onPressed: () => _showNewCategorySheet(context),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textTertiary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: categoriesAsync.when(
              data: (categories) {
                return ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: AppColors.surfaceElevatedHigh,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    String hex = category.colorHex;
                    if (hex.length == 6) hex = 'FF$hex';
                    final color = Color(int.parse(hex, radix: 16));
                    return ListTile(
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(category.icon, style: const TextStyle(fontSize: 20)),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
                      ),
                      trailing: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      onTap: () {},
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: AppColors.semanticUrgent))),
            ),
          ),
        ],
      ),
    );
  }
}

class NewCategorySheet extends ConsumerStatefulWidget {
  const NewCategorySheet({super.key});

  @override
  ConsumerState<NewCategorySheet> createState() => _NewCategorySheetState();
}

class _NewCategorySheetState extends ConsumerState<NewCategorySheet> {
  final TextEditingController _nameController = TextEditingController();
  final List<Color> _colors = [
    AppColors.semanticUrgent,
    Colors.orange,
    Colors.yellow,
    AppColors.semanticPositive,
    Colors.blue,
    Colors.purple,
    Colors.pink,
  ];
  Color _selectedColor = Colors.blue;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceObsidian,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'New Category',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textTertiary),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Name',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'e.g. Groceries',
              hintStyle: const TextStyle(color: AppColors.borderSpecular),
              filled: true,
              fillColor: AppColors.surfaceElevatedHigh,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.md),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Color',
            style: TextStyle(
              color: AppColors.textTertiary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: _colors.map((color) {
              final isSelected = color == _selectedColor;
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: AppColors.textPrimary, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                final dao = ref.read(expenseDaoProvider);
                final name = _nameController.text;
                if (name.isEmpty) return;

                // ignore: deprecated_member_use
                final colorHex = _selectedColor.value.toRadixString(16).padLeft(8, '0');
                
                final newCat = ExpenseCategoriesCompanion.insert(
                  name: name,
                  icon: '✨', // Default icon for custom
                  colorHex: colorHex,
                );
                
                await dao.insertCategory(newCat);
                if (context.mounted) Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentViolet,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                ),
              ),
              child: const Text(
                'Save Category',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
