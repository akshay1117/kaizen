import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';
import 'custom_numpad.dart';

class AddSubscriptionModal extends ConsumerStatefulWidget {
  const AddSubscriptionModal({super.key});

  @override
  ConsumerState<AddSubscriptionModal> createState() => _AddSubscriptionModalState();
}

class _AddSubscriptionModalState extends ConsumerState<AddSubscriptionModal> {
  final TextEditingController _nameController = TextEditingController();
  String _amount = "0.00";
  final DateTime _startDate = DateTime.now();

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

  Future<void> _saveSubscription() async {
    final name = _nameController.text.trim();
    final double? parsedAmount = double.tryParse(_amount);
    
    if (name.isEmpty || parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter name and valid amount.')));
      return;
    }

    final dao = ref.read(expenseDaoProvider);
    final currentTrackerId = ref.read(selectedTrackerIdProvider);
    if (currentTrackerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No active tracker selected.')));
      return;
    }

    await dao.insertSubscription(
      ExpenseSubscriptionsCompanion.insert(
        trackerId: currentTrackerId,
        name: name,
        amount: parsedAmount,
        interval: const drift.Value('1 Month'),
        startDate: _startDate,
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
                const Text('New Subscription', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _saveSubscription,
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
                  Text('₹$_amount', style: const TextStyle(color: Colors.white, fontSize: 56, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Subscription Name (e.g. Netflix)',
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
