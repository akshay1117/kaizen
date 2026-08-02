import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class BoxingHomeScreen extends StatelessWidget {
  const BoxingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassScaffold(
      appBar: GlassAppBar(title: Text('Boxing')),
      body: Center(child: Text('Boxing training module is being wired up.')),
    );
  }
}
