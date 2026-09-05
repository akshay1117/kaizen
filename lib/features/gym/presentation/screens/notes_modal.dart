import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';

class NotesModal extends ConsumerWidget {
  final String workoutName;
  const NotesModal({super.key, required this.workoutName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        leading: IconButton(
          icon: const Icon(Icons.close, color: GymTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Notes', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: GymTheme.primaryAccent,
              radius: 14,
              child: Icon(Icons.check, color: AppColors.textPrimary, size: 18),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tip Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.article, color: GymTheme.textSecondary),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Useful Notes', style: TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Set goals or targets, list instructions, or add reminders.', style: TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {}, // Dismiss
                  child: const Icon(Icons.close, color: GymTheme.textSecondary, size: 20),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          
          Text('$workoutName Description', style: const TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: const TextField(
              style: TextStyle(color: GymTheme.textPrimary),
              decoration: InputDecoration(
                hintText: 'Add workout note',
                hintStyle: TextStyle(color: GymTheme.textSecondary),
                border: InputBorder.none,
              ),
              maxLines: null,
            ),
          ),
          
          const SizedBox(height: 24),
          const Text('Exercises', style: TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bench Press', style: TextStyle(color: GymTheme.textPrimary)),
                TextField(
                  style: TextStyle(color: GymTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Add note',
                    hintStyle: TextStyle(color: GymTheme.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
                Divider(color: GymTheme.pillUnselected),
                SizedBox(height: 8),
                Text('Squat', style: TextStyle(color: GymTheme.textPrimary)),
                TextField(
                  style: TextStyle(color: GymTheme.textPrimary),
                  decoration: InputDecoration(
                    hintText: 'Add note',
                    hintStyle: TextStyle(color: GymTheme.textSecondary),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'These notes will only appear in this Workout.',
              style: TextStyle(color: GymTheme.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
