import 'package:flutter/material.dart';

class BoxingHomeScreen extends StatelessWidget {
  const BoxingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Boxing')),
      body: const Center(child: Text('Boxing training module is being wired up.')),
    );
  }
}
