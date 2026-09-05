import 'package:kaizen/core/theme/app_spacing.dart';
import 'package:kaizen/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class StreakGoalScreen extends StatefulWidget {
  final String initialGoal;

  const StreakGoalScreen({super.key, required this.initialGoal});

  @override
  State<StreakGoalScreen> createState() => _StreakGoalScreenState();
}

class _StreakGoalScreenState extends State<StreakGoalScreen> {
  late String _selectedGoal;
  
  final List<String> _goals = ['None', 'Daily', 'Week', 'Month'];

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.initialGoal.isNotEmpty ? widget.initialGoal : 'None';
    // capitalize first letter if needed
    _selectedGoal = _selectedGoal[0].toUpperCase() + _selectedGoal.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      backgroundColor: AppColors.surfacePitchBlack, // Dark background matching the screenshot
      appBar: GlassAppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context, _selectedGoal),
        ),
        title: const Text('Streak Goal', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interval',
              style: TextStyle(color: AppColors.textTertiary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfacePitchBlack,
                borderRadius: BorderRadius.circular(AppRadii.md),
                border: Border.all(color: AppColors.surfaceElevatedHigh, width: 1),
              ),
              child: Column(
                children: _goals.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String goal = entry.value;
                  bool isSelected = _selectedGoal == goal;
                  return Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                        title: Text(goal, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16)),
                        trailing: isSelected ? const Icon(Icons.check, color: AppColors.textPrimary, size: 20) : null,
                        onTap: () {
                          setState(() {
                            _selectedGoal = goal;
                          });
                          Future.delayed(const Duration(milliseconds: 150), () {
                            if (!context.mounted) return;
                            Navigator.pop(context, _selectedGoal);
                          });
                        },
                      ),
                      if (idx < _goals.length - 1)
                        const Divider(height: 1, color: AppColors.surfaceElevatedHigh, indent: 16, endIndent: 16),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
