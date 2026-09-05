import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaizen/features/gym/presentation/screens/gym_shell_screen.dart';

// --- Gym Home Screen ---
class GymHomeScreen extends ConsumerWidget {
  const GymHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const GymShellScreen();
  }
}
