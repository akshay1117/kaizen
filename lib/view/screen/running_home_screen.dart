import 'package:flutter/material.dart';

class RunningHomeScreen extends StatelessWidget {
  const RunningHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Running')),
      body: const Center(child: Text('Running analytics and logs are on the way.')),
    );
  }
}
