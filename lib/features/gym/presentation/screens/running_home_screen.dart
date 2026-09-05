import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

class RunningHomeScreen extends StatelessWidget {
  const RunningHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GlassScaffold(
      appBar: GlassAppBar(title: Text('Running')),
      body: Center(child: Text('Running analytics and logs are on the way.')),
    );
  }
}
