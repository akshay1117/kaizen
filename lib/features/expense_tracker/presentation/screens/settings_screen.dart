import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class ExpenseSettingsScreen extends StatelessWidget {
  const ExpenseSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      appBar: GlassAppBar(
        backgroundColor: Colors.black,
        title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Center(child: Text('Settings List Here', style: TextStyle(color: Colors.white))),
    );
  }
}
