import 'package:flutter/material.dart';

class GymHomeScreen extends StatelessWidget {
  const GymHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gym')),
      body: const Center(child: Text('Workout logging coming soon — with exercise library, PR tracking, and volume analytics.')),
    );
  }
}