import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'custom_numpad.dart';
import 'category_selector_bottom_sheet.dart';
import 'account_selector_bottom_sheet.dart';
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';

import '../../data/expense_dao.dart';

class AddExpenseModal extends ConsumerStatefulWidget {
  final TransactionWithDetails? existingTransaction;
  const AddExpenseModal({super.key, this.existingTransaction});

  @override
  ConsumerState<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends ConsumerState<AddExpenseModal> {
  String _amount = "";
  ExpenseCategory? _selectedCategory;
  ExpenseAccount? _selectedAccount;
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  List<String> _attachments = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final existing = widget.existingTransaction;
    if (existing != null) {
      _amount = existing.transaction.amount.toStringAsFixed(2);
      if (_amount.endsWith('.00')) {
        _amount = _amount.substring(0, _amount.length - 3);
      }
      _selectedCategory = existing.category;
      _selectedAccount = existing.account;
      _noteController.text = existing.transaction.note ?? '';
      _selectedDate = existing.transaction.date;
      if (existing.transaction.attachments != null) {
        try {
          _attachments = List<String>.from(jsonDecode(existing.transaction.attachments!));
        } catch (_) {}
      }
    }
  }

  void _onNumberTapped(String number) {
    setState(() {
      _amount += number;
    });
  }

  void _onBackspaceTapped() {
    setState(() {
      if (_amount.isNotEmpty) {
        _amount = _amount.substring(0, _amount.length - 1);
      }
    });
  }

  void _onDotTapped() {
    setState(() {
      if (!_amount.contains('.')) {
        if (_amount.isEmpty) {
          _amount += '0.';
        } else {
          _amount += '.';
        }
      }
    });
  }

  Future<void> _saveExpense() async {
    final double? parsedAmount = double.tryParse(_amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a valid amount.')));
      return;
    }
    
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a category.')));
      return;
    }

    final dao = ref.read(expenseDaoProvider);
    final currentTrackerId = ref.read(selectedTrackerIdProvider);

    try {
      if (widget.existingTransaction != null) {
        final existingTx = widget.existingTransaction!.transaction;
        await dao.updateTransaction(
          ExpenseTransaction(
            id: existingTx.id,
            trackerId: existingTx.trackerId,
            accountId: _selectedAccount?.id,
            categoryId: _selectedCategory!.id,
            memberId: existingTx.memberId,
            amount: parsedAmount,
            isIncome: _selectedCategory!.isIncome,
            date: _selectedDate,
            note: _noteController.text.isNotEmpty ? _noteController.text : null,
            attachments: _attachments.isNotEmpty ? jsonEncode(_attachments) : null,
            createdAt: existingTx.createdAt,
          ),
        );
      } else {
        await dao.insertTransaction(
          ExpenseTransactionsCompanion.insert(
            trackerId: currentTrackerId != null ? drift.Value(currentTrackerId) : const drift.Value.absent(),
            accountId: _selectedAccount != null ? drift.Value(_selectedAccount!.id) : const drift.Value.absent(),
            categoryId: _selectedCategory!.id,
            amount: parsedAmount,
            isIncome: drift.Value(_selectedCategory!.isIncome),
            date: _selectedDate,
            note: _noteController.text.isNotEmpty ? drift.Value(_noteController.text) : const drift.Value.absent(),
            attachments: _attachments.isNotEmpty ? drift.Value(jsonEncode(_attachments)) : const drift.Value.absent(),
          ),
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e, st) {
      debugPrint('Error saving expense: $e\n$st');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFmt = ref.watch(currencyFormatterProvider);
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _selectedDate) {
                      setState(() {
                        _selectedDate = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _selectedDate.day == DateTime.now().day && _selectedDate.month == DateTime.now().month && _selectedDate.year == DateTime.now().year
                          ? 'Today'
                          : DateFormat('MMM d, yyyy').format(_selectedDate),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _amount = "";
                    });
                  },
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  // Amount Display
                  Text(
                    '${currencyFmt.currencySymbol}${_amount.isEmpty ? '0' : _amount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  
                  // Attachment Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                            if (image != null) {
                              setState(() {
                                _attachments.add(image.path);
                              });
                            }
                          },
                          child: _buildAttachmentButton(Icons.camera_alt, 'Scan', isPro: false),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () async {
                            final List<XFile> images = await _picker.pickMultiImage();
                            if (images.isNotEmpty) {
                              setState(() {
                                _attachments.addAll(images.map((e) => e.path));
                              });
                            }
                          },
                          child: _buildAttachmentButton(Icons.photo, 'Photos', isPro: false),
                        ),
                        const SizedBox(width: 8),
                        _buildAttachmentButton(Icons.folder, 'Files', isPro: true),
                      ],
                    ),
                  ),
                  if (_attachments.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 60,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _attachments.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2C2E),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.image, color: Colors.white),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _attachments.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 12),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  
                  // Note Input & Account Row
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _noteController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Name / Note',
                            hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                            filled: true,
                            fillColor: const Color(0xFF1C1C1E),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => SizedBox(
                                height: MediaQuery.of(context).size.height * 0.7,
                                child: AccountSelectorBottomSheet(
                                  onAccountSelected: (account) {
                                    setState(() {
                                      _selectedAccount = account;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _selectedAccount != null ? const Color(0xFF0A84FF) : Colors.transparent, width: 1.5),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.account_balance_wallet, color: _selectedAccount != null ? const Color(0xFF0A84FF) : const Color(0xFF8E8E93), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _selectedAccount != null ? _selectedAccount!.name : 'Account',
                                    style: TextStyle(color: _selectedAccount != null ? Colors.white : const Color(0xFF8E8E93), fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Category & Save Row
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => CategorySelectorBottomSheet(
                                onCategorySelected: (category) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1C1C1E),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _selectedCategory != null ? Color(int.parse(_selectedCategory!.colorHex, radix: 16)) : const Color(0xFF0A84FF), width: 1.5),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              _selectedCategory != null ? '${_selectedCategory!.icon} ${_selectedCategory!.name}' : 'Select Category',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: _saveExpense,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A84FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          
          // Numpad
          CustomNumpad(
            onNumberTapped: _onNumberTapped,
            onBackspaceTapped: _onBackspaceTapped,
            onDotTapped: _onDotTapped,
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentButton(IconData icon, String label, {bool isPro = false}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF3A3A3C)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        if (isPro)
          Positioned(
            right: 8,
            top: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9500), // Orange PRO badge
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
