import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';
import 'custom_numpad.dart';

class AddInstallmentModal extends ConsumerStatefulWidget {
  const AddInstallmentModal({super.key});

  @override
  ConsumerState<AddInstallmentModal> createState() => _AddInstallmentModalState();
}

class _AddInstallmentModalState extends ConsumerState<AddInstallmentModal> {
  final TextEditingController _nameController = TextEditingController();
  String _amount = "0.00";

  void _onNumberTapped(String number) {
    setState(() {
      if (_amount == "0.00") {
        _amount = number;
      } else {
        _amount += number;
      }
    });
  }

  void _onBackspaceTapped() {
    setState(() {
      if (_amount.length > 1) {
        _amount = _amount.substring(0, _amount.length - 1);
      } else {
        _amount = "0.00";
      }
    });
  }

  void _onDotTapped() {
    setState(() {
      if (!_amount.contains('.')) {
        _amount += '.';
      }
    });
  }

  Future<void> _saveInstallment() async {
    final name = _nameController.text.trim();
    final double? parsedAmount = double.tryParse(_amount);
    
    if (name.isEmpty || parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter name and valid total amount.')));
      return;
    }

    final dao = ref.read(expenseDaoProvider);
    final currentTrackerId = ref.read(selectedTrackerIdProvider);
    if (currentTrackerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active tracker selected.')));
      return;
    }

    await dao.insertInstallment(
      ExpenseInstallmentsCompanion.insert(
        trackerId: currentTrackerId,
        name: name,
        totalAmount: parsedAmount,
        installmentAmount: parsedAmount,
        startDate: DateTime.now(),
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text('New Installment', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _saveInstallment,
                  child: const Text('Save', style: TextStyle(color: Color(0xFF0A84FF), fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF2C2C2E), height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text('Total Amount', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 16)),
                  Text('₹$_amount', style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Installment Name (e.g. Car EMI)',
                      hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                      filled: true,
                      fillColor: const Color(0xFF1C1C1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomNumpad(
            onNumberTapped: _onNumberTapped,
            onBackspaceTapped: _onBackspaceTapped,
            onDotTapped: _onDotTapped,
          ),
        ],
      ),
    );
  }
}
