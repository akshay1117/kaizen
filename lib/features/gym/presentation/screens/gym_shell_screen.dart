import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/theme/gym_theme.dart';
import 'package:kaizen/features/gym/presentation/screens/workouts_home_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/sessions_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/body_screen.dart';
import 'package:kaizen/features/gym/presentation/screens/today_screen.dart';

class GymShellScreen extends ConsumerStatefulWidget {
  const GymShellScreen({super.key});

  @override
  ConsumerState<GymShellScreen> createState() => _GymShellScreenState();
}

class _GymShellScreenState extends ConsumerState<GymShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    WorkoutsHomeScreen(),
    SessionsScreen(),
    BodyScreen(),
    TodayScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: GymTheme.darkTheme,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Sets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.timer_outlined),
              label: 'Sessions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new),
              label: 'Body',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Today',
            ),
          ],
        ),
      ),
    );
  }
}
