import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/presentation/screens/exercises_index_screen.dart';

class WorkoutsHomeScreen extends ConsumerWidget {
  const WorkoutsHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ungroupedWorkoutsAsync = ref.watch(ungroupedWorkoutsProvider);
    final workoutGroupsAsync = ref.watch(workoutGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: GymTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.settings),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.flame, color: GymTheme.textSecondary),
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Edit', style: TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildActionRow(
                    icon: Icons.add,
                    title: 'New Workout...',
                    subtitle: 'e.g., Upper Body, Leg Day, Monday Routine',
                    iconColor: GymTheme.primaryAccent,
                    onTap: () => _showNewWorkoutDialog(context, ref),
                  ),
                  const Divider(color: GymTheme.pillUnselected, height: 1),
                  _buildActionRow(
                    icon: Icons.auto_awesome,
                    title: 'New Custom Plan...',
                    iconColor: GymTheme.primaryAccent,
                    onTap: () {},
                  ),
                  const Divider(color: GymTheme.pillUnselected, height: 1),
                  _buildActionRow(
                    icon: Icons.menu_book,
                    title: 'My Exercises',
                    iconColor: GymTheme.primaryAccent,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ExercisesIndexScreen()),
                      );
                    },
                    trailing: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('0', style: TextStyle(color: GymTheme.textSecondary, fontSize: 16)),
                        Icon(Icons.chevron_right, color: GymTheme.textSecondary),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Ungrouped Workouts
          ungroupedWorkoutsAsync.when(
            data: (workouts) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final workout = workouts[index];
                  return Dismissible(
                    key: Key(workout.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(workoutDaoProvider).deleteWorkout(workout);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.fitness_center, color: GymTheme.destructive),
                      title: Text(workout.name, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 18)),
                      trailing: const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
                      onTap: () {},
                    ),
                  );
                },
                childCount: workouts.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator())),
            error: (e, st) => SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),

          // Workout Groups
          workoutGroupsAsync.when(
            data: (groups) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final group = groups[index];
                  return Dismissible(
                    key: Key(group.id),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) {
                      ref.read(workoutDaoProvider).deleteWorkoutGroup(group);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.folder, color: GymTheme.volumeAccent),
                      title: Text(group.name, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 18)),
                      trailing: const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
                      onTap: () {},
                    ),
                  );
                },
                childCount: groups.length,
              ),
            ),
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (e, st) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: GymTheme.primaryAccent,
        label: const Text('Add Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GymTheme.pillRadius)),
      ),
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconColor,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Icon(icon, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: GymTheme.primaryAccent, fontSize: 16, fontWeight: FontWeight.w500)),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
                  ],
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showNewWorkoutDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: GymTheme.cardBackground,
          title: const Text('New Workout', style: TextStyle(color: GymTheme.textPrimary)),
          content: TextField(
            controller: nameController,
            autofocus: true,
            style: const TextStyle(color: GymTheme.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Workout Name',
              hintStyle: TextStyle(color: GymTheme.textSecondary),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: GymTheme.pillUnselected)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: GymTheme.primaryAccent)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: GymTheme.textSecondary)),
            ),
            TextButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty) {
                  final dao = ref.read(workoutDaoProvider);
                  // Use the generated class WorkoutsCompanion to insert a new row
                  await dao.insertWorkout(
                    WorkoutsCompanion.insert(
                      name: nameController.text.trim(),
                    ),
                  );
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: GymTheme.primaryAccent, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }
}
