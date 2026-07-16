import 'package:flutter/material.dart';

class DietHomeScreen extends StatelessWidget {
  const DietHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diet')),
      body: const Center(child: Text('Diet planning and nutrition insights are being added.')),
    );
  }
}
