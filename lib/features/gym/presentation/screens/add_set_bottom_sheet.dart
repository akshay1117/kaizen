import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class AddSetBottomSheet extends ConsumerStatefulWidget {
  const AddSetBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddSetBottomSheet(),
    );
  }

  @override
  ConsumerState<AddSetBottomSheet> createState() => _AddSetBottomSheetState();
}

class _AddSetBottomSheetState extends ConsumerState<AddSetBottomSheet> {
  double _reps = 10;
  double _weight = 20;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: GymTheme.cardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: GymTheme.pillUnselected,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildStepper(
                  label: 'Reps',
                  value: '$_reps',
                  onDecrement: () {
                    if (_reps > 0) setState(() => _reps -= 1);
                  },
                  onIncrement: () {
                    setState(() => _reps += 1);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStepper(
                  label: 'Weight',
                  value: '$_weight',
                  onDecrement: () {
                    if (_weight > 0) setState(() => _weight -= 2.5);
                  },
                  onIncrement: () {
                    setState(() => _weight += 2.5);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionChip('Label', Icons.label_outline),
                const SizedBox(width: 8),
                _buildActionChip('Plates', Icons.fitness_center),
                const SizedBox(width: 8),
                _buildActionChip('KG', null, isUnit: true),
                const SizedBox(width: 8),
                _buildActionChip('Now', Icons.access_time),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            style: TextStyle(color: GymTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'Add note',
              hintStyle: TextStyle(color: GymTheme.textSecondary),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: GymTheme.primaryAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Set', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper({
    required String label,
    required String value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: GymTheme.textSecondary, fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: GymTheme.primaryAccent, size: 32),
              onPressed: onDecrement,
            ),
            Text(value, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 32, fontWeight: FontWeight.bold)),
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: GymTheme.primaryAccent, size: 32),
              onPressed: onIncrement,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionChip(String label, IconData? icon, {bool isUnit = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: GymTheme.pillUnselected,
        borderRadius: BorderRadius.circular(GymTheme.pillRadius),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: GymTheme.textSecondary, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: isUnit ? GymTheme.primaryAccent : GymTheme.textSecondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
