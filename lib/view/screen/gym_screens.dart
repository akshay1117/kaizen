import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaizen/model/gym_models.dart';
import 'package:kaizen/services/design_tokens.dart';
import 'package:cached_network_image/cached_network_image.dart';

// --- State Management ---
// Persistent provider for Workout Splits
final workoutSplitsProvider = StateNotifierProvider<WorkoutSplitsNotifier, List<WorkoutSplit>>((ref) {
  return WorkoutSplitsNotifier();
});

class WorkoutSplitsNotifier extends StateNotifier<List<WorkoutSplit>> {
  WorkoutSplitsNotifier() : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('workout_splits');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      state = jsonList.map((e) => WorkoutSplit.fromJson(e)).toList();
    }
  }

  Future<void> _saveToPrefs(List<WorkoutSplit> splits) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(splits.map((e) => e.toJson()).toList());
    await prefs.setString('workout_splits', data);
  }

  void addOrUpdateSplit(WorkoutSplit split, int? index) {
    if (index != null) {
      final newState = List<WorkoutSplit>.from(state);
      newState[index] = split;
      state = newState;
    } else {
      state = [...state, split];
    }
    _saveToPrefs(state);
  }

  void removeSplit(int index) {
    final newState = List<WorkoutSplit>.from(state);
    newState.removeAt(index);
    state = newState;
    _saveToPrefs(state);
  }
}

// Persistent provider for Custom Exercises
final customExercisesProvider = StateNotifierProvider<CustomExercisesNotifier, List<Exercise>>((ref) {
  return CustomExercisesNotifier();
});

class CustomExercisesNotifier extends StateNotifier<List<Exercise>> {
  CustomExercisesNotifier() : super([]) {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('custom_exercises');
    if (data != null) {
      final List<dynamic> jsonList = jsonDecode(data);
      state = jsonList.map((e) => Exercise.fromJson(e)).toList();
    }
  }

  Future<void> _saveToPrefs(List<Exercise> exercises) async {
    final prefs = await SharedPreferences.getInstance();
    final String data = jsonEncode(exercises.map((e) => e.toJson()).toList());
    await prefs.setString('custom_exercises', data);
  }

  void addExercise(Exercise exercise) {
    state = [...state, exercise];
    _saveToPrefs(state);
  }

  void removeExercise(String id) {
    state = state.where((e) => e.id != id).toList();
    _saveToPrefs(state);
  }
}

// --- Gym Home Screen ---
class GymHomeScreen extends ConsumerWidget {
  const GymHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splits = ref.watch(workoutSplitsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Gym', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomExercisesListScreen()),
              );
            },
          ),
        ],
      ),
      body: splits.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.fitness_center, size: 64, color: DesignTokens.textTertiary),
                  SizedBox(height: 16),
                  Text(
                    'No workout splits yet.',
                    style: TextStyle(color: DesignTokens.textSecondary, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: splits.length,
              itemBuilder: (context, index) {
                final split = splits[index];
                final activeDays = split.days.where((d) => d.exercises.isNotEmpty).length;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateSplitScreen(
                          existingSplit: split,
                          index: index,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: const Color(0xFF1E1E1E),
                        title: const Text('Delete Split', style: TextStyle(color: Colors.white)),
                        content: Text('Are you sure you want to delete "${split.name}"?', style: const TextStyle(color: DesignTokens.textSecondary)),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel', style: TextStyle(color: DesignTokens.textTertiary)),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(workoutSplitsProvider.notifier).removeSplit(index);
                              Navigator.pop(context);
                            },
                            child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          split.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$activeDays Workout Days',
                          style: const TextStyle(color: DesignTokens.accentGym),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'create_exercise_home',
            backgroundColor: const Color(0xFF1E1E1E),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateExerciseScreen()),
              );
            },
            icon: const Icon(Icons.fitness_center, color: DesignTokens.accentGym),
            label: const Text('Create Exercise', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 16),
          FloatingActionButton.extended(
            heroTag: 'create_split_home',
            backgroundColor: DesignTokens.accentGym,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateSplitScreen()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.black),
            label: const Text('Create Split', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// --- Create Split Screen ---
class CreateSplitScreen extends ConsumerStatefulWidget {
  final WorkoutSplit? existingSplit;
  final int? index;

  const CreateSplitScreen({super.key, this.existingSplit, this.index});

  @override
  ConsumerState<CreateSplitScreen> createState() => _CreateSplitScreenState();
}

class _CreateSplitScreenState extends ConsumerState<CreateSplitScreen> {
  final TextEditingController _nameController = TextEditingController();
  
  late List<SplitDay> _days;

  @override
  void initState() {
    super.initState();
    if (widget.existingSplit != null) {
      _nameController.text = widget.existingSplit!.name;
      // create copies of days so we don't mutate original before saving
      _days = widget.existingSplit!.days.map((d) => d.copyWith()).toList();
    } else {
      _days = [
        SplitDay(dayOfWeek: 'Monday', label: ''),
        SplitDay(dayOfWeek: 'Tuesday', label: ''),
        SplitDay(dayOfWeek: 'Wednesday', label: ''),
        SplitDay(dayOfWeek: 'Thursday', label: ''),
        SplitDay(dayOfWeek: 'Friday', label: ''),
        SplitDay(dayOfWeek: 'Saturday', label: ''),
        SplitDay(dayOfWeek: 'Sunday', label: ''),
      ];
    }
  }

  void _saveSplit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a split name')),
      );
      return;
    }

    final newSplit = WorkoutSplit(
      id: widget.existingSplit?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      days: _days,
    );

    ref.read(workoutSplitsProvider.notifier).addOrUpdateSplit(newSplit, widget.index);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(widget.existingSplit != null ? 'Edit Weekly Split' : 'New Weekly Split'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveSplit,
            child: const Text('Save', style: TextStyle(color: DesignTokens.accentGym, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.edit_calendar, color: DesignTokens.accentGym),
                  hintText: 'Split Name (e.g., Push/Pull/Legs)',
                  hintStyle: TextStyle(color: DesignTokens.textTertiary, fontWeight: FontWeight.normal),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Weekly Schedule',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _days.length,
                itemBuilder: (context, index) {
                  final day = _days[index];
                  final hasExercises = day.exercises.isNotEmpty;
                  return GestureDetector(
                    onTap: () async {
                      final updatedDay = await Navigator.push<SplitDay>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DayExercisesScreen(day: day),
                        ),
                      );
                      if (updatedDay != null) {
                        setState(() {
                          _days[index] = updatedDay;
                        });
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: hasExercises ? DesignTokens.accentGym.withAlpha(128) : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: hasExercises
                            ? [
                                BoxShadow(
                                  color: DesignTokens.accentGym.withAlpha(26),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : [],
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 90,
                            child: Text(
                              day.dayOfWeek,
                              style: TextStyle(
                                color: hasExercises ? Colors.white : Colors.white70,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2A2A2A),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                onChanged: (val) {
                                  _days[index] = _days[index].copyWith(label: val);
                                },
                                controller: TextEditingController(text: day.label)
                                  ..selection = TextSelection.fromPosition(
                                    TextPosition(offset: day.label.length),
                                  ),
                                style: const TextStyle(color: DesignTokens.accentGym, fontSize: 14),
                                decoration: const InputDecoration(
                                  hintText: 'Add label (e.g. Push)',
                                  hintStyle: TextStyle(color: DesignTokens.textTertiary, fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${day.exercises.length} Exercises',
                                style: TextStyle(
                                  color: hasExercises ? DesignTokens.accentGym : DesignTokens.textSecondary,
                                  fontSize: 12,
                                  fontWeight: hasExercises ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(Icons.chevron_right, color: DesignTokens.textTertiary, size: 20),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Day Exercises Screen ---
class DayExercisesScreen extends StatefulWidget {
  final SplitDay day;

  const DayExercisesScreen({super.key, required this.day});

  @override
  State<DayExercisesScreen> createState() => _DayExercisesScreenState();
}

class _DayExercisesScreenState extends State<DayExercisesScreen> {
  late SplitDay _currentDay;

  @override
  void initState() {
    super.initState();
    _currentDay = widget.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text('${_currentDay.dayOfWeek} Exercises'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, _currentDay),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Exercises',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final selected = await Navigator.push<List<Exercise>>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectExerciseScreen(
                          alreadySelected: _currentDay.exercises,
                        ),
                      ),
                    );
                    if (selected != null) {
                      setState(() {
                        _currentDay = _currentDay.copyWith(exercises: selected);
                      });
                    }
                  },
                  icon: const Icon(Icons.add, color: DesignTokens.accentGym),
                  label: const Text('Add', style: TextStyle(color: DesignTokens.accentGym)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _currentDay.exercises.isEmpty
                  ? const Center(
                      child: Text(
                        'No exercises added yet.',
                        style: TextStyle(color: DesignTokens.textSecondary),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _currentDay.exercises.length,
                      itemBuilder: (context, index) {
                        final ex = _currentDay.exercises[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  ex.name,
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                onPressed: () {
                                  setState(() {
                                    final newList = List<Exercise>.from(_currentDay.exercises)..removeAt(index);
                                    _currentDay = _currentDay.copyWith(exercises: newList);
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Select Exercise Screen ---
class SelectExerciseScreen extends ConsumerStatefulWidget {
  final List<Exercise> alreadySelected;

  const SelectExerciseScreen({super.key, required this.alreadySelected});

  @override
  ConsumerState<SelectExerciseScreen> createState() => _SelectExerciseScreenState();
}

class _SelectExerciseScreenState extends ConsumerState<SelectExerciseScreen> {
  final Set<String> _selectedIds = {};
  String _searchQuery = '';
  late List<Exercise> _currentSelection;

  @override
  void initState() {
    super.initState();
    _currentSelection = List.from(widget.alreadySelected);
    _selectedIds.addAll(_currentSelection.map((e) => e.id));
  }

  void _toggleExercise(Exercise ex) {
    setState(() {
      if (_selectedIds.contains(ex.id)) {
        _selectedIds.remove(ex.id);
        _currentSelection.removeWhere((e) => e.id == ex.id);
      } else {
        _selectedIds.add(ex.id);
        _currentSelection.add(ex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(customExercisesProvider);
    final filtered = exercises.where((ex) => ex.name.toLowerCase().contains(_searchQuery)).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Select Exercises'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            backgroundColor: DesignTokens.accentGym,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateExerciseScreen(),
                ),
              );
            },
            child: const Icon(Icons.add, color: Colors.black),
          ),
          const SizedBox(height: 16),
          if (_currentSelection.isNotEmpty)
            FloatingActionButton.extended(
              heroTag: 'confirm',
              backgroundColor: DesignTokens.accentGym,
              onPressed: () {
                Navigator.pop(context, _currentSelection);
              },
              icon: const Icon(Icons.check, color: Colors.black),
              label: Text('Confirm (${_currentSelection.length})', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF2A2A2A)),
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: DesignTokens.textTertiary),
                  hintText: 'Search custom exercises...',
                  hintStyle: TextStyle(color: DesignTokens.textTertiary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Text(
                      'No exercises found.\nTap + to create one.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: DesignTokens.textSecondary, fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final ex = filtered[index];
                      final isSelected = _selectedIds.contains(ex.id);
                      
                      return GestureDetector(
                        onTap: () => _toggleExercise(ex),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? DesignTokens.accentGym : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              if (ex.mediaId.isNotEmpty)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: "https://cdn.jsdelivr.net/gh/Johnson-Jia/exercises-dataset@main/media/${ex.mediaId}.gif",
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const SizedBox(
                                      width: 48,
                                      height: 48,
                                      child: Center(child: CircularProgressIndicator(color: DesignTokens.accentGym, strokeWidth: 2)),
                                    ),
                                    errorWidget: (context, url, error) => Container(
                                      width: 48,
                                      height: 48,
                                      color: Colors.black26,
                                      child: const Icon(Icons.broken_image, size: 24, color: DesignTokens.textTertiary),
                                    ),
                                  ),
                                )
                              else
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF2A2A2A),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(Icons.fitness_center, color: DesignTokens.textTertiary),
                                  ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ex.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${ex.bodyPart} • ${ex.target}",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: DesignTokens.textSecondary, fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.circle_outlined,
                                  color: isSelected ? DesignTokens.accentGym : DesignTokens.textTertiary,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    }
  }

// --- Create Exercise Screen ---
class CreateExerciseScreen extends ConsumerStatefulWidget {
  const CreateExerciseScreen({super.key});

  @override
  ConsumerState<CreateExerciseScreen> createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends ConsumerState<CreateExerciseScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _equipmentController = TextEditingController();

  void _saveExercise() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an exercise name')),
      );
      return;
    }

    final newEx = Exercise(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      bodyPart: 'Custom',
      target: _targetController.text.trim(),
      secondaryMuscles: [],
      equipment: _equipmentController.text.trim(),
      mediaId: '',
      instructions: [],
    );

    ref.read(customExercisesProvider.notifier).addExercise(newEx);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Create Exercise'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveExercise,
            child: const Text('Save', style: TextStyle(color: DesignTokens.accentGym, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInput(_nameController, 'Exercise Name', Icons.fitness_center),
            const SizedBox(height: 16),
            _buildInput(_targetController, 'Target Muscle (e.g., Chest)', Icons.ads_click),
            const SizedBox(height: 16),
            _buildInput(_equipmentController, 'Equipment (e.g., Dumbbell)', Icons.handyman),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: DesignTokens.accentGym),
          hintText: hint,
          hintStyle: const TextStyle(color: DesignTokens.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

// --- Custom Exercises List Screen ---
class CustomExercisesListScreen extends ConsumerWidget {
  const CustomExercisesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exercises = ref.watch(customExercisesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Custom Exercises'),
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
      ),
      body: exercises.isEmpty
          ? const Center(
              child: Text(
                'No custom exercises found.\nCreate one from the Gym home screen.',
                textAlign: TextAlign.center,
                style: TextStyle(color: DesignTokens.textSecondary, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                final ex = exercises[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E1E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A2A),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.fitness_center, color: DesignTokens.textTertiary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ex.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ex.target.isNotEmpty ? ex.target : 'Custom Exercise',
                              style: const TextStyle(
                                color: DesignTokens.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: const Color(0xFF1E1E1E),
                              title: const Text('Delete Exercise', style: TextStyle(color: Colors.white)),
                              content: const Text('Are you sure you want to delete this custom exercise?', style: TextStyle(color: DesignTokens.textSecondary)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel', style: TextStyle(color: DesignTokens.textTertiary)),
                                ),
                                TextButton(
                                  onPressed: () {
                                    ref.read(customExercisesProvider.notifier).removeExercise(ex.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

