import 'package:flutter/material.dart';

import 'package:kaizen/features/gym/presentation/screens/sets_tab.dart';
import 'package:kaizen/features/gym/presentation/screens/sessions_tab.dart';
import 'package:kaizen/features/gym/presentation/screens/body_tab.dart';
import 'package:kaizen/features/gym/presentation/screens/today_tab.dart';

class GymHubScreen extends StatefulWidget {
  const GymHubScreen({super.key});

  @override
  State<GymHubScreen> createState() => _GymHubScreenState();
}

class _GymHubScreenState extends State<GymHubScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    SetsTab(),
    SessionsTab(),
    BodyTab(),
    TodayTab(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gym'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Sets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.accessibility_new),
            label: 'Body',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Today',
          ),
        ],
      ),
    );
  }
}
