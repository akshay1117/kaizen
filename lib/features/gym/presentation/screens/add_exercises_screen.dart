import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'dart:convert';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kaizen/features/gym/data/gym_database.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/providers/exercise_providers.dart';
import 'package:kaizen/features/gym/presentation/providers/workout_providers.dart';
import 'package:drift/drift.dart' as drift;

class ApiExercise {
  final String id;
  final String name;

  ApiExercise({required this.id, required this.name});

  factory ApiExercise.fromJson(Map<String, dynamic> json) {
    return ApiExercise(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }
}

class AddExercisesScreen extends ConsumerStatefulWidget {
  final String workoutId;
  final String workoutName;
  const AddExercisesScreen({super.key, required this.workoutId, required this.workoutName});

  @override
  ConsumerState<AddExercisesScreen> createState() => _AddExercisesScreenState();
}

class _AddExercisesScreenState extends ConsumerState<AddExercisesScreen> {
  final Set<String> _selectedExerciseIds = {};
  // Map ID to Name so we know the name when saving
  final Map<String, String> _selectedExerciseNames = {};

  List<ApiExercise> _apiExercises = [];
  bool _isLoadingApi = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchApiExercises();
  }

  Future<void> _fetchApiExercises() async {
    try {
      final response = await http.get(Uri.parse('https://raw.githubusercontent.com/yuhonas/free-exercise-db/main/dist/exercises.json'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          _apiExercises = jsonList.map((e) => ApiExercise.fromJson(e)).toList();
          _isLoadingApi = false;
        });
      } else {
        setState(() => _isLoadingApi = false);
      }
    } catch (e) {
      setState(() => _isLoadingApi = false);
    }
  }

  void _saveAndPop(List<Exercise> existingMyExercises) async {
    final dao = ref.read(exerciseDaoProvider);
    final workoutDao = ref.read(workoutDaoProvider);
    final existingMyExerciseNames = existingMyExercises.map((e) => e.name).toList();

    int stepOrder = DateTime.now().millisecondsSinceEpoch; // basic ordering

    // For any selected API exercise that isn't already in My Exercises, insert it.
    for (final id in _selectedExerciseIds) {
      String localExerciseId = id;

      if (id.startsWith('api_')) {
        final name = _selectedExerciseNames[id];
        if (name != null) {
          if (!existingMyExerciseNames.contains(name)) {
             final newExerciseId = const Uuid().v4();
             await dao.insertExercise(
              ExercisesCompanion.insert(
                id: drift.Value(newExerciseId),
                name: name,
                primaryMuscles: const [],
                secondaryMuscles: const [],
              ),
            );
            localExerciseId = newExerciseId;
          } else {
             localExerciseId = existingMyExercises.firstWhere((e) => e.name == name).id;
          }
        }
      }

      if (widget.workoutId != 'library') {
        try {
          await workoutDao.insertWorkoutStep(WorkoutStepsCompanion.insert(
            workoutId: widget.workoutId,
            stepType: 0,
            refId: localExerciseId,
            stepOrder: stepOrder++,
          ));
        } catch (e) {
          debugPrint('Error inserting workout step: $e');
        }
      }
    }

    if (mounted) {
      Navigator.pop(context, _selectedExerciseIds.toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    final myExercisesAsync = ref.watch(allExercisesProvider);

    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,
        title: Text('Add to "${widget.workoutName}"', style: const TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: GymTheme.primaryAccent,
              radius: 14,
              child: Icon(Icons.check, color: AppColors.textPrimary, size: 18),
            ),
            onPressed: () {
              final myExercises = myExercisesAsync.valueOrNull ?? [];
              _saveAndPop(myExercises);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: GymTheme.cardBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  style: const TextStyle(color: GymTheme.textPrimary),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                  decoration: const InputDecoration(
                    hintText: 'Search or enter exercise name',
                    hintStyle: TextStyle(color: GymTheme.textSecondary),
                    prefixIcon: Icon(Icons.search, color: GymTheme.textSecondary),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),
          ),

          // My Exercises Section
          myExercisesAsync.when(
            data: (exercises) {
              final filtered = exercises.where((e) => e.name.toLowerCase().contains(_searchQuery)).toList();
              if (filtered.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());

              return SliverList(
                delegate: SliverChildListDelegate([
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text('My Exercises', style: TextStyle(color: GymTheme.textSecondary, fontWeight: FontWeight.bold)),
                  ),
                  ...filtered.map((e) => _buildRow(e.name, e.id, true)),
                ]),
              );
            },
            loading: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
            error: (e, st) => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // API Section
          SliverList(
            delegate: SliverChildListDelegate([
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text('From Database', style: TextStyle(color: GymTheme.textSecondary, fontWeight: FontWeight.bold)),
              ),
              if (_isLoadingApi)
                const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()))
              else ...() {
                final filtered = _apiExercises.where((e) => e.name.toLowerCase().contains(_searchQuery)).toList();
                // To avoid massive list rendering block, we'll just show up to 100 results at a time
                final limited = filtered.take(100).toList();
                return limited.map((e) => _buildRow(e.name, 'api_${e.id}', false));
              }(),
            ]),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildRow(String name, String id, bool isMyExercise) {
    final isSelected = _selectedExerciseIds.contains(id);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedExerciseIds.remove(id);
            _selectedExerciseNames.remove(id);
          } else {
            _selectedExerciseIds.add(id);
            _selectedExerciseNames[id] = name;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            const Icon(Icons.add, color: GymTheme.primaryAccent, size: 20),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(name, style: const TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: GymTheme.primaryAccent, size: 24)
            else
              const Icon(Icons.radio_button_unchecked, color: GymTheme.textSecondary, size: 24),
          ],
        ),
      ),
    );
  }
}
