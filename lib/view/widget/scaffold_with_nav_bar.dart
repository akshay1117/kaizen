import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return GlassScaffold(
      body: navigationShell,
      bottomBar: GlassTabBar.bottom(
        selectedIndex: navigationShell.currentIndex,
        onTabSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        tabs: const [
          GlassTab(icon: Icon(Icons.home), label: 'Home'),
          GlassTab(icon: Icon(Icons.fitness_center), label: 'Fitness'),
          GlassTab(icon: Icon(Icons.attach_money), label: 'Finance'),
          GlassTab(icon: Icon(Icons.book), label: 'Journal'),
          GlassTab(icon: Icon(Icons.insights), label: 'Habits'), // Index 4
        ],
      ),
    );
  }
}