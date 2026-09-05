import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart';
import 'package:kaizen/features/gym/presentation/screens/add_exercises_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExercisesIndexScreen extends ConsumerWidget {
  const ExercisesIndexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(allExercisesProvider);

    return GlassScaffold(
      appBar: GlassAppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: GymTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Exercises', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: GymTheme.background,

        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_horiz, color: GymTheme.textPrimary),
            color: GymTheme.cardBackground,
            onSelected: (value) {
              // Handle Sort By or Show Help
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'sort',
                child: Row(
                  children: [
                    Icon(Icons.swap_vert, color: GymTheme.textPrimary, size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sort By', style: TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
                          Text('Most Recently Done', style: TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: GymTheme.textSecondary, size: 20),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'help',
                child: Row(
                  children: [
                    Icon(Icons.help_outline, color: GymTheme.textPrimary, size: 20),
                    SizedBox(width: 12),
                    Text('Show Help', style: TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            exercisesAsync.when(
              data: (exercises) {
                return Column(
                  children: [
                    const SizedBox(height: 56), // Clear the GlassAppBar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: GymTheme.cardBackground,
                          borderRadius: BorderRadius.circular(AppRadii.lg), // Match list container radius
                        ),
                        child: const TextField(
                          style: TextStyle(color: GymTheme.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Search exercises...',
                            hintStyle: TextStyle(color: GymTheme.textSecondary),
                            prefixIcon: Icon(Icons.search, color: GymTheme.textSecondary),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: GymTheme.cardBackground,
                            borderRadius: BorderRadius.circular(AppRadii.lg),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: exercises.isEmpty
                              ? const Center(
                                  child: Text('No custom exercises yet.', style: TextStyle(color: GymTheme.textSecondary)),
                                )
                              : ListView.separated(
                                  padding: const EdgeInsets.only(bottom: 80),
                                  itemCount: exercises.length,
                                  separatorBuilder: (context, index) => const Divider(color: GymTheme.pillUnselected, height: 1),
                                  itemBuilder: (context, index) {
                                    final exercise = exercises[index];
                                    return Slidable(
                                      key: Key(exercise.id),
                                      endActionPane: ActionPane(
                                        motion: const ScrollMotion(),
                                        dismissible: DismissiblePane(onDismissed: () {
                                          ref.read(exerciseDaoProvider).deleteExercise(exercise);
                                        }),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) {
                                              ref.read(exerciseDaoProvider).deleteExercise(exercise);
                                            },
                                            backgroundColor: AppColors.semanticUrgent,
                                            foregroundColor: AppColors.textPrimary,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Text(exercise.name, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
                                        trailing: SizedBox(
                                          width: 100,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              if (index == 0) ...[
                                                const Text('Today', style: TextStyle(color: GymTheme.textSecondary, fontSize: 14)),
                                                const SizedBox(width: 8),
                                              ],
                                              const Icon(Icons.help_outline, color: GymTheme.textSecondary, size: 20),
                                              const SizedBox(width: 8),
                                              const Icon(Icons.chevron_right, color: GymTheme.textSecondary, size: 20),
                                            ],
                                          ),
                                        ),
                                        onTap: () {
                                          // Navigate to ExerciseDetailScreen
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddExercisesScreen(workoutId: 'library', workoutName: 'Library'),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  backgroundColor: GymTheme.cardBackground,
                  label: const Text('Add Exercises', style: TextStyle(color: GymTheme.primaryAccent, fontWeight: FontWeight.bold, fontSize: 16)),
                  icon: const Icon(Icons.add, color: GymTheme.primaryAccent),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GymTheme.pillRadius)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
