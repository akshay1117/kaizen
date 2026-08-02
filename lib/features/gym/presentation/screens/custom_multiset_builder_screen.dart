import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/screens/add_exercises_screen.dart';

class CustomMultisetBuilderScreen extends ConsumerStatefulWidget {
  const CustomMultisetBuilderScreen({super.key});

  @override
  ConsumerState<CustomMultisetBuilderScreen> createState() =>
      _CustomMultisetBuilderScreenState();
}

class _CustomMultisetBuilderScreenState
    extends ConsumerState<CustomMultisetBuilderScreen> {
  final _nameController = TextEditingController();
  bool _checkOffEachSet = true;

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: GymTheme.background,
      appBar: GlassAppBar(
        backgroundColor: GymTheme.background,

        title: const Text('New Multiset', style: TextStyle(fontSize: 16)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: GymTheme.primaryAccent,
              radius: 14,
              child: Icon(Icons.check, color: Colors.white, size: 18),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              controller: _nameController,
              style: const TextStyle(color: GymTheme.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Name (Optional)',
                hintStyle: TextStyle(color: GymTheme.textSecondary),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Steps',
              style: TextStyle(
                  color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.drag_indicator,
                      color: GymTheme.textSecondary),
                  title: const Text('Bench Press',
                      style: TextStyle(color: GymTheme.textPrimary)),
                  trailing: const Icon(Icons.remove_circle,
                      color: GymTheme.destructive),
                  onTap: () {},
                ),
                const Divider(color: GymTheme.pillUnselected, height: 1),
                ListTile(
                  leading: const Icon(Icons.add, color: GymTheme.primaryAccent),
                  title: const Text('Add exercise',
                      style: TextStyle(color: GymTheme.primaryAccent)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const AddExercisesScreen(workoutName: 'Multiset'),
                        fullscreenDialog: true,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Rest',
              style: TextStyle(
                  color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Between sets',
                      style: TextStyle(color: GymTheme.textPrimary)),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Default',
                          style: TextStyle(color: GymTheme.textSecondary)),
                      Icon(Icons.chevron_right, color: GymTheme.textSecondary),
                    ],
                  ),
                  onTap: () {},
                ),
                const Divider(color: GymTheme.pillUnselected, height: 1),
                ListTile(
                  title: const Text('After the Multiset',
                      style: TextStyle(color: GymTheme.textPrimary)),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('None',
                          style: TextStyle(color: GymTheme.textSecondary)),
                      Icon(Icons.chevron_right, color: GymTheme.textSecondary),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Logging',
              style: TextStyle(
                  color: GymTheme.textPrimary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: GymTheme.cardBackground,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: const Text('Check off each set',
                  style: TextStyle(color: GymTheme.textPrimary)),
              activeThumbColor: GymTheme.primaryAccent,
              value: _checkOffEachSet,
              onChanged: (val) => setState(() => _checkOffEachSet = val),
            ),
          ),
        ],
      ),
    );
  }
}
