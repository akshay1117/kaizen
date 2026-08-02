import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:drift/drift.dart' as drift;

import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/custom_keypad.dart';
import 'package:kaizen/features/expense_tracker/presentation/widgets/category_picker.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  bool _isIncome = false;
  String _amountStr = '0';
  String? _selectedCategoryId;
  String _note = '';

  void _onDigit(String digit) {
    setState(() {
      if (_amountStr == '0' && digit != '.') {
        _amountStr = digit;
      } else if (digit == '.' && _amountStr.contains('.')) {
        // do nothing
      } else {
        _amountStr += digit;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (_amountStr.length > 1) {
        _amountStr = _amountStr.substring(0, _amountStr.length - 1);
      } else {
        _amountStr = '0';
      }
    });
  }

  void _onDone() async {
    final amount = double.tryParse(_amountStr) ?? 0.0;
    if (amount <= 0 || _selectedCategoryId == null) return;

    final dao = ref.read(expenseDaoProvider);
    await dao.insertTransaction(ExpenseTransactionsCompanion.insert(
      categoryId: _selectedCategoryId!,
      amount: amount,
      isIncome: drift.Value(_isIncome),
      date: DateTime.now(),
      note: _note.isNotEmpty ? drift.Value(_note) : const drift.Value.absent(),
    ));

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final currencyFmt = ref.watch(currencyFormatterProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: GlassAppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: _buildToggle(),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('How much?', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    '${currencyFmt.currencySymbol}$_amountStr',
                    style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Note',
                      hintStyle: const TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFF1A1A1A),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => _note = v,
                  ),
                  const SizedBox(height: 24),
                  
                  categoriesAsync.when(
                    data: (categories) {
                      final filtered = categories.where((c) => c.isIncome == _isIncome).toList();
                      return CategoryPicker(
                        categories: filtered,
                        selectedCategoryId: _selectedCategoryId,
                        onCategorySelected: (id) => setState(() => _selectedCategoryId = id),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, st) => Text('Error: $e'),
                  ),
                ],
              ),
            ),
          ),
          
          CustomKeypad(
            onDigit: _onDigit,
            onBackspace: _onBackspace,
            onDone: _onDone,
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => setState(() { _isIncome = false; _selectedCategoryId = null; }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: !_isIncome ? const Color(0xFF2F86FF) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('Expense', style: TextStyle(color: !_isIncome ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() { _isIncome = true; _selectedCategoryId = null; }),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: _isIncome ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text('Income', style: TextStyle(color: _isIncome ? Colors.white : Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
