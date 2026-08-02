import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class DietHomeScreen extends StatelessWidget {
  const DietHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassScaffold(
      appBar: GlassAppBar(title: Text('Diet')),
      body: Center(child: Text('Diet planning and nutrition insights are being added.')),
    );
  }
}
