import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart';
import 'package:kaizen/features/gym/presentation/screens/add_exercises_screen.dart';

class ExercisesIndexScreen extends ConsumerWidget {
  const ExercisesIndexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercisesAsync = ref.watch(allExercisesProvider);

    return GlassScaffold(
      appBar: GlassAppBar(
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
      body: Stack(
        children: [
          exercisesAsync.when(
            data: (exercises) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: GymTheme.cardBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const TextField(
                        style: TextStyle(color: GymTheme.textPrimary),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: GymTheme.textSecondary),
                          prefixIcon: Icon(Icons.search, color: GymTheme.textSecondary),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          borderRadius: BorderRadius.circular(16),
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
                                  return Dismissible(
                                    key: Key(exercise.id),
                                    direction: DismissDirection.endToStart,
                                    onDismissed: (_) {
                                      ref.read(exerciseDaoProvider).deleteExercise(exercise);
                                    },
                                    background: Container(
                                      color: Colors.red,
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      child: const Icon(Icons.delete, color: Colors.white),
                                    ),
                                    child: ListTile(
                                      title: Text(exercise.name, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (index == 0) // Mocking "Today" for the first item
                                            const Text('Today', style: TextStyle(color: GymTheme.textSecondary, fontSize: 14)),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.help_outline, color: GymTheme.textSecondary, size: 20),
                                          const SizedBox(width: 8),
                                          const Icon(Icons.chevron_right, color: GymTheme.textSecondary, size: 20),
                                        ],
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
                      builder: (context) => const AddExercisesScreen(workoutName: 'Library'),
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
    );
  }
}
