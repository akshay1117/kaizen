import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/screens/add_set_bottom_sheet.dart';

class ExerciseDetailScreen extends ConsumerStatefulWidget {
  final String exerciseId;
  final String exerciseName;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    required this.exerciseName,
  });

  @override
  ConsumerState<ExerciseDetailScreen> createState() =>
      _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends ConsumerState<ExerciseDetailScreen> {
  int _tabIndex = 0; // 0: Sets, 1: Analyze, 2: 1RM

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GymTheme.background,
      appBar: AppBar(
        backgroundColor: GymTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left,
              color: GymTheme.textPrimary, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.exerciseName,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
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
            child: _buildSelectedTab(),
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
            Expanded(child: _buildSegmentButton('Sets', 0)),
            Expanded(child: _buildSegmentButton('Analyze', 1)),
            Expanded(child: _buildSegmentButton('1RM', 2)),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentButton(String label, int index) {
    final isSelected = _tabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _tabIndex = index),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? GymTheme.pillSelected : Colors.transparent,
          borderRadius: BorderRadius.circular(GymTheme.pillRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? GymTheme.pillTextSelected
                  : GymTheme.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTab() {
    switch (_tabIndex) {
      case 0:
        return _buildSetsTab();
      case 1:
        return _buildAnalyzeTab();
      case 2:
        return _build1RMTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSetsTab() {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Compared to Previous
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GymTheme.cardBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Compared to Previous',
                      style: TextStyle(
                          color: GymTheme.textPrimary,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatDelta('Sets', '3', '+1'),
                      _buildStatDelta('Reps', '25', '+5'),
                      _buildStatDelta('Volume', '1250', '+250'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Example empty state or past sets
            const Center(
              child: Text('No Sets\nRecord sets to progress every session.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: GymTheme.textSecondary)),
            ),
          ],
        ),
        Positioned(
          bottom: 32,
          right: 16,
          child: Column(
            children: [
              FloatingActionButton(
                heroTag: 'multiset_fab',
                mini: true,
                backgroundColor: GymTheme.cardBackground,
                onPressed: () {},
                child: const Icon(Icons.layers, color: GymTheme.primaryAccent),
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'add_set_fab',
                backgroundColor: GymTheme.primaryAccent,
                onPressed: () {
                  AddSetBottomSheet.show(context);
                }, // Will open add set bottom sheet
                child: const Icon(Icons.add, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatDelta(String label, String value, String delta) {
    return Column(
      children: [
        Text(label,
            style:
                const TextStyle(color: GymTheme.textSecondary, fontSize: 13)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: GymTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: GymTheme.primaryAccent.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(delta,
              style: const TextStyle(
                  color: GymTheme.primaryAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildAnalyzeTab() {
    return const Center(
        child: Text('Analytics Unavailable',
            style: TextStyle(color: GymTheme.textSecondary)));
  }

  Widget _build1RMTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('1 Rep Max',
                  style: TextStyle(color: GymTheme.textPrimary, fontSize: 16)),
              Switch(
                value: true,
                onChanged: (val) {},
                activeThumbColor: GymTheme.primaryAccent,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: GymTheme.cardBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Formula',
                style: TextStyle(color: GymTheme.textPrimary)),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Average',
                    style: TextStyle(color: GymTheme.textSecondary)),
                Icon(Icons.chevron_right, color: GymTheme.textSecondary),
              ],
            ),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
