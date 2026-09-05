import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class FinanceHomeScreen extends StatelessWidget {
  const FinanceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassScaffold(
      appBar: GlassAppBar(title: Text('Finance')),
      body: Center(child: Text('Finance tracking will appear here soon.')),
    );
  }
}
