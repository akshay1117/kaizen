import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/expense_tracker/application/expense_providers.dart';
import 'package:kaizen/features/expense_tracker/data/expense_database.dart';
import 'package:drift/drift.dart' as drift;

class NewTrackerModal extends ConsumerStatefulWidget {
  const NewTrackerModal({super.key});

  @override
  ConsumerState<NewTrackerModal> createState() => _NewTrackerModalState();
}

class _NewTrackerModalState extends ConsumerState<NewTrackerModal> {
  final _nameController = TextEditingController();
  final _budgetController = TextEditingController();
  String _budgetCycle = 'Monthly'; // 'One-Time' or 'Monthly'

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFF121212),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 8),
          Container(
            width: 32,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const Text(
                  'New Tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 64), // Balance spacing
              ],
            ),
          ),
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              children: [
                // Icon
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A84FF).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: Color(0xFF0A84FF), size: 32),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Titles
                const Text(
                  'Create a new tracker',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Give your tracker a clear name, e.g. "Bali 2025" or "Business expenses".',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                
                // Form Fields (Tracker Name, Budget, Cycle)
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tracker Name
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Text('Tracker Name', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'e.g. Vacation, Business',
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const Divider(color: Color(0xFF2C2C2E), height: 1, indent: 16),
                      
                      // Budget
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Row(
                          children: [
                            Text('Budget (₹)', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                            const SizedBox(width: 4),
                            Icon(Icons.info_outline, color: Colors.white.withValues(alpha: 0.5), size: 14),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: TextField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: const InputDecoration(
                            hintText: 'Optional - e.g. 1500',
                            hintStyle: TextStyle(color: Colors.white30),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const Divider(color: Color(0xFF2C2C2E), height: 1, indent: 16),
                      
                      // Budget Cycle
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Budget Cycle', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _budgetCycle = 'One-Time'),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _budgetCycle == 'One-Time' ? const Color(0xFF2C2C2E) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _budgetCycle == 'One-Time' ? const Color(0xFF3A3A3C) : Colors.transparent,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'One-Time',
                                        style: TextStyle(
                                          color: _budgetCycle == 'One-Time' ? Colors.white : Colors.white54,
                                          fontWeight: _budgetCycle == 'One-Time' ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _budgetCycle = 'Monthly'),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: _budgetCycle == 'Monthly' ? const Color(0xFF2C2C2E) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: _budgetCycle == 'Monthly' ? const Color(0xFF3A3A3C) : Colors.transparent,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Monthly',
                                        style: TextStyle(
                                          color: _budgetCycle == 'Monthly' ? Colors.white : Colors.white54,
                                          fontWeight: _budgetCycle == 'Monthly' ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Create Tracker Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nameController.text.isNotEmpty ? () async {
                      final dao = ref.read(expenseDaoProvider);
                      final budgetVal = double.tryParse(_budgetController.text);
                      
                      final newTracker = ExpenseTrackersCompanion.insert(
                        name: _nameController.text,
                        budget: budgetVal != null ? drift.Value(budgetVal) : const drift.Value.absent(),
                        cycleType: drift.Value(_budgetCycle),
                      );
                      
                      // We need the inserted ID, but insertTracker might just return internal row id.
                      // Let's generate the ID manually to be safe, or just query it back if we need it.
                      // Actually, the DAO generates the ID by default if absent! Wait, let's just supply an ID
                      // so we can set it to active immediately.
                      final trackerId = '${DateTime.now().millisecondsSinceEpoch}';
                      final trackerWithId = newTracker.copyWith(id: drift.Value(trackerId));
                      
                      await dao.insertTracker(trackerWithId);
                      
                      ref.read(selectedTrackerIdProvider.notifier).state = trackerId;
                      
                      if (context.mounted) Navigator.pop(context);
                    } : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C2C2E), // Uses dark color when disabled
                      disabledBackgroundColor: const Color(0xFF2C2C2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ).copyWith(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.disabled)) {
                          return const Color(0xFF2C2C2E);
                        }
                        return const Color(0xFF0A84FF);
                      }),
                    ),
                    child: Text(
                      'Create Tracker',
                      style: TextStyle(
                        color: _nameController.text.isNotEmpty ? Colors.white : Colors.white54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
