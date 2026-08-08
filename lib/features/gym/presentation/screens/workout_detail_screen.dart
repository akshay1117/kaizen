import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/screens/add_exercises_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/exercise_detail_screen.dart';
import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';

class WorkoutDetailScreen extends ConsumerStatefulWidget {
  final String workoutId;
  final String workoutName;

  const WorkoutDetailScreen({
    super.key,
    required this.workoutId,
    required this.workoutName,
  });

  @override
  ConsumerState<WorkoutDetailScreen> createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends ConsumerState<WorkoutDetailScreen> {
  int _tabIndex = 0; // 0 for Info, 1 for Notes

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: GymTheme.textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.workoutName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share, color: GymTheme.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_horiz, color: GymTheme.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSegmentedControl(),
          Expanded(
            child: _tabIndex == 0 ? _buildInfoTab() : _buildNotesTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: GymTheme.pillUnselected,
          borderRadius: BorderRadius.circular(GymTheme.pillRadius),
        ),
        child: Row(
          children: [
            Expanded(child: _buildSegmentButton('Info', 0, Icons.info_outline)),
            Expanded(child: _buildSegmentButton('Notes', 1, Icons.notes)),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String label, int index, IconData icon) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? GymTheme.pillSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(GymTheme.pillRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: isSelected ? GymTheme.pillTextSelected : GymTheme.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? GymTheme.pillTextSelected : GymTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab() {
    final exercisesAsync = ref.watch(workoutExercisesProvider(widget.workoutId));
    
    return Column(
      children: [
        Expanded(
          child: exercisesAsync.when(
            data: (exercises) {
              if (exercises.isEmpty) {
                return const Center(
                  child: Text('No exercises added yet.', style: TextStyle(color: GymTheme.textSecondary)),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    title: Text(exercise.name, style: const TextStyle(color: GymTheme.textPrimary)),
                    trailing: const Icon(Icons.chevron_right, color: GymTheme.textSecondary),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetailScreen(
                            exerciseId: exercise.id,
                            exerciseName: exercise.name,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: GymTheme.destructive))),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 32.0, left: 16.0, right: 16.0),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddExercisesScreen(
                          workoutId: widget.workoutId,
                          workoutName: widget.workoutName,
                        ),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: GymTheme.primaryAccent, size: 18),
                  label: const Text('Exercises', style: TextStyle(color: GymTheme.textPrimary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GymTheme.cardBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GymTheme.pillRadius)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.layers, color: GymTheme.destructive, size: 18),
                  label: const Text('Multisets', style: TextStyle(color: GymTheme.textPrimary)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GymTheme.cardBackground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(GymTheme.pillRadius)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // Tip Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
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
        
        Text('${widget.workoutName} Description', style: const TextStyle(color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: GymTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
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
            borderRadius: BorderRadius.circular(16),
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
    );
  }
}
