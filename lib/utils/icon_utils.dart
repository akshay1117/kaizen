import 'package:flutter/material.dart';

IconData getHabitIcon(String name) {
  switch (name) {
    case 'wallet': return Icons.account_balance_wallet;
    case 'moon': return Icons.nights_stay;
    case 'camera': return Icons.camera_alt;
    case 'coffee': return Icons.local_cafe;
    case 'fitness': return Icons.fitness_center;
    case 'book': return Icons.menu_book;
    case 'medication': return Icons.medication;
    case 'water': return Icons.water_drop;
    case 'favorite': return Icons.favorite;
    case 'restaurant': return Icons.restaurant_menu;
    case 'directions_run': return Icons.directions_run;
    case 'directions_walk': return Icons.directions_walk;
    case 'self_improvement': return Icons.self_improvement;
    case 'laptop': return Icons.laptop_mac;
    case 'show_chart': return Icons.show_chart;
    default: return Icons.favorite; // fallback
  }
}
