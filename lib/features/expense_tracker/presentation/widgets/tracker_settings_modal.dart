import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import '../../application/expense_providers.dart';
import '../../data/expense_database.dart';
import 'custom_numpad.dart';

class TrackerSettingsModal extends ConsumerStatefulWidget {
  final ExpenseTracker? existingTracker;
  const TrackerSettingsModal({super.key, this.existingTracker});

  @override
  ConsumerState<TrackerSettingsModal> createState() => _TrackerSettingsModalState();
}

class _TrackerSettingsModalState extends ConsumerState<TrackerSettingsModal> {
  final TextEditingController _nameController = TextEditingController();
  bool _budgetEnabled = false;
  String _budgetAmount = "0.00";

  @override
  void initState() {
    super.initState();
    if (widget.existingTracker != null) {
      _nameController.text = widget.existingTracker!.name;
      if (widget.existingTracker!.budget != null) {
        _budgetEnabled = true;
        _budgetAmount = widget.existingTracker!.budget!.toStringAsFixed(2);
      }
    }
  }

  void _onNumberTapped(String number) {
    if (!_budgetEnabled) return;
    setState(() {
      if (_budgetAmount == "0.00") {
        _budgetAmount = number;
      } else {
        _budgetAmount += number;
      }
    });
  }

  void _onBackspaceTapped() {
    if (!_budgetEnabled) return;
    setState(() {
      if (_budgetAmount.length > 1) {
        _budgetAmount = _budgetAmount.substring(0, _budgetAmount.length - 1);
      } else {
        _budgetAmount = "0.00";
      }
    });
  }

  void _onDotTapped() {
    if (!_budgetEnabled) return;
    setState(() {
      if (!_budgetAmount.contains('.')) {
        _budgetAmount += '.';
      }
    });
  }

  Future<void> _saveTracker() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a tracker name.')));
      return;
    }

    final double? parsedBudget = _budgetEnabled ? double.tryParse(_budgetAmount) : null;
    final dao = ref.read(expenseDaoProvider);

    if (widget.existingTracker != null) {
      // Update
      await dao.updateTracker(
        widget.existingTracker!.copyWith(
          name: name,
          budget: drift.Value(parsedBudget),
        ),
      );
    } else {
      // Insert
      await dao.insertTracker(
        ExpenseTrackersCompanion.insert(
          name: name,
          budget: drift.Value(parsedBudget),
        ),
      );
    }

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
                Text(widget.existingTracker != null ? 'Edit Tracker' : 'New Tracker', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: _saveTracker,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Tracker Name (e.g. Goa Trip, Family)',
                      hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
                      filled: true,
                      fillColor: const Color(0xFF1C1C1E),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SwitchListTile(
                    title: const Text('Monthly Budget', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                    subtitle: const Text('Set a limit for this tracker.', style: TextStyle(color: Color(0xFF8E8E93), fontSize: 14)),
                    activeTrackColor: const Color(0xFF0A84FF),
                    value: _budgetEnabled,
                    onChanged: (val) => setState(() => _budgetEnabled = val),
                    contentPadding: EdgeInsets.zero,
                  ),
                  if (_budgetEnabled) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Text('₹$_budgetAmount', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
            ),
          ),
          if (_budgetEnabled)
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
