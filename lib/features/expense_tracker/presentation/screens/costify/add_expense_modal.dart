import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';
import 'package:drift/drift.dart' as drift;

class AddExpenseModal extends ConsumerStatefulWidget {
  const AddExpenseModal({super.key});

  @override
  ConsumerState<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends ConsumerState<AddExpenseModal> {
  String _amount = "0";
  final TextEditingController _noteController = TextEditingController();
  ExpenseCategory? _selectedCategory;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onDigitPress(String digit) {
    setState(() {
      if (_amount == "0" && digit != ".") {
        _amount = digit;
      } else if (digit == "." && _amount.contains(".")) {
        // do nothing
      } else {
        _amount += digit;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = "0";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.95,
      decoration: const BoxDecoration(
        color: AppColors.surfaceObsidian,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  onPressed: () => Navigator.pop(context),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevatedHigh,
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                  child: const Text("Today", style: TextStyle(color: AppColors.textPrimary)),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.textPrimary),
                  onPressed: () => setState(() => _amount = "0"),
                ),
              ],
            ),
          ),
          
          // Amount Display
          Expanded(
            child: Center(
              child: Text(
                '₹${_amount == "0" ? "0.00" : _amount}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          
          // Inputs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _noteController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Name / Note',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surfaceElevatedHigh,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadii.lg),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevatedHigh,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.credit_card, color: AppColors.textSecondary, size: 20),
                        SizedBox(width: 8),
                        Expanded(child: Text('No account (optional)', style: TextStyle(color: AppColors.textPrimary))),
                        Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    final categoriesAsync = ref.watch(categoriesProvider);
                    final categories = categoriesAsync.valueOrNull ?? [];
                    final currentCat = _selectedCategory ?? (categories.isNotEmpty ? categories.first : null);
                    
                    Color catColor = const Color(0xFF81b0ff); // default fallback
                    if (currentCat != null) {
                      String hex = currentCat.colorHex;
                      if (hex.length == 6) hex = 'FF$hex';
                      catColor = Color(int.parse(hex, radix: 16));
                    }
                    
                    // Mix color with white for pastel pill look
                    final pillColor = Color.lerp(catColor, AppColors.textPrimary, 0.2) ?? catColor;
                    
                    return PopupMenuButton<ExpenseCategory>(
                      color: AppColors.surfaceElevatedHigh,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.xl)),
                      offset: const Offset(0, -300),
                      onSelected: (cat) => setState(() => _selectedCategory = cat),
                      itemBuilder: (context) {
                        return categories.map((cat) {
                          return PopupMenuItem<ExpenseCategory>(
                            value: cat,
                            child: Row(
                              children: [
                                Text(cat.icon, style: const TextStyle(fontSize: 20)),
                                const SizedBox(width: 12),
                                Text(cat.name, style: const TextStyle(color: AppColors.textPrimary)),
                              ],
                            ),
                          );
                        }).toList();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: pillColor,
                          borderRadius: BorderRadius.circular(AppRadii.xl),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(currentCat?.icon ?? '✨', style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Text(
                              currentCat?.name ?? 'Select', 
                              style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textSecondary,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.xl)),
                  ),
                  onPressed: () async {
                    final dao = ref.read(expenseDaoProvider);
                    final amountVal = double.tryParse(_amount) ?? 0.0;
                    if (amountVal <= 0) return;
                    
                    final categories = await dao.watchAllCategories().first;
                    final defaultCat = categories.isNotEmpty ? categories.first.id : 'cat_food';
                    final catId = _selectedCategory?.id ?? defaultCat;
                    
                    final currentTrackerId = ref.read(selectedTrackerIdProvider);
                    
                    final newExpense = ExpenseTransactionsCompanion.insert(
                      amount: amountVal,
                      date: DateTime.now(),
                      isIncome: const drift.Value(false),
                      categoryId: catId,
                      trackerId: currentTrackerId != null ? drift.Value(currentTrackerId) : const drift.Value.absent(),
                      note: _noteController.text.isNotEmpty ? drift.Value(_noteController.text) : const drift.Value.absent(),
                    );
                    
                    await dao.insertTransaction(newExpense);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save', style: TextStyle(color: AppColors.surfaceElevatedHigh, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          // Numpad
          Container(
            color: AppColors.surfacePitchBlack,
            padding: const EdgeInsets.only(bottom: 32, top: 16),
            child: _buildNumpad(),
          ),
        ],
      ),
    );
  }


  Widget _buildNumpad() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildKey('1'),
            _buildKey('2'),
            _buildKey('3'),
          ],
        ),
        Row(
          children: [
            _buildKey('4'),
            _buildKey('5'),
            _buildKey('6'),
          ],
        ),
        Row(
          children: [
            _buildKey('7'),
            _buildKey('8'),
            _buildKey('9'),
          ],
        ),
        Row(
          children: [
            _buildKey('.'),
            _buildKey('0'),
            _buildIconKey(Icons.backspace_outlined, _onBackspace),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String label) {
    return Expanded(
      child: InkWell(
        onTap: () => _onDigitPress(label),
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Text(label, style: const TextStyle(fontSize: 28, color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildIconKey(IconData icon, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          alignment: Alignment.center,
          child: Icon(icon, color: AppColors.textPrimary, size: 28),
        ),
      ),
    );
  }
}
