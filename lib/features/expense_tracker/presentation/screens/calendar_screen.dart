import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class ExpenseCalendarScreen extends StatelessWidget {
  const ExpenseCalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      appBar: GlassAppBar(
        backgroundColor: Colors.black,
        title: Text('Calendar', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Center(child: Text('Calendar View Here', style: TextStyle(color: Colors.white))),
    );
  }
}
