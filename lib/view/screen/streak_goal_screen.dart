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
      backgroundColor: const Color(0xFF141414), // Dark background matching the screenshot
      appBar: GlassAppBar(
        backgroundColor: Colors.transparent,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.white),
          onPressed: () => Navigator.pop(context, _selectedGoal),
        ),
        title: const Text('Streak Goal', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Interval',
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0F0F11),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF2C2C2E), width: 1),
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
                        title: Text(goal, style: const TextStyle(color: Colors.white, fontSize: 16)),
                        trailing: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
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
                        const Divider(height: 1, color: Color(0xFF2C2C2E), indent: 16, endIndent: 16),
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
