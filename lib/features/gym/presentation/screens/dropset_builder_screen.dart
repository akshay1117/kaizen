import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class DropsetBuilderScreen extends ConsumerStatefulWidget {
  final String workoutName;
  const DropsetBuilderScreen({super.key, required this.workoutName});

  @override
  ConsumerState<DropsetBuilderScreen> createState() => _DropsetBuilderScreenState();
}

class _DropsetBuilderScreenState extends ConsumerState<DropsetBuilderScreen> {
  int _sets = 3;
  String? _selectedExerciseId;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        title: const Text('New Dropset', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: GymTheme.primaryAccent,
              radius: 14,
              child: Icon(Icons.check, color: AppColors.textPrimary, size: 18),
            ),
            onPressed: () {
              // Save dropset
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Sets', style: TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline, color: GymTheme.primaryAccent),
                      onPressed: () {
                        if (_sets > 2) setState(() => _sets--);
                      },
                    ),
                    Text('$_sets', style: const TextStyle(color: GymTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline, color: GymTheme.primaryAccent),
                      onPressed: () {
                        setState(() => _sets++);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Text('Exercise', style: TextStyle(color: GymTheme.textSecondary, fontWeight: FontWeight.bold)),
          const SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildExerciseRadio('e1', 'Bench Press'),
                const Divider(color: GymTheme.pillUnselected),
                _buildExerciseRadio('e2', 'Squat'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'A dropset requires selecting an exercise already added to this workout.',
              style: TextStyle(color: GymTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseRadio(String id, String name) {
    final isSelected = _selectedExerciseId == id;
    return InkWell(
      onTap: () => setState(() => _selectedExerciseId = id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Expanded(child: Text(name, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 16))),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? GymTheme.primaryAccent : GymTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
