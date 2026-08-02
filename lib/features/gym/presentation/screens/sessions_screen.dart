import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionsScreen extends ConsumerWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GlassScaffold(
      appBar: GlassAppBar(title: Text('Sessions')),
      body: Center(child: Text('Sessions List')),
    );
  }
}
