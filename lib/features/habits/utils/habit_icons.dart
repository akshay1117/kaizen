import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HabitIconCategory {
  final String name;
  final Map<String, IconData> icons;

  const HabitIconCategory({required this.name, required this.icons});
}

// Map string identifiers to Lucide Icons
final List<HabitIconCategory> habitIconCategories = [
  const HabitIconCategory(
    name: 'Activities',
    icons: {
      'briefcase': LucideIcons.briefcase,
      'location_pin': LucideIcons.mapPin,
      'phone': LucideIcons.phone,
      'cart': LucideIcons.shoppingCart,
      'anchor': LucideIcons.anchor,
      'chair': LucideIcons.armchair,
      'backpack': LucideIcons.backpack,
      'bathtub': LucideIcons.bath,
      'bed': LucideIcons.bed,
      'book': LucideIcons.book,
      'code': LucideIcons.code,
      'target': LucideIcons.target,
      'dice': LucideIcons.dice3,
      'game': LucideIcons.gamepad2,
      'headphones': LucideIcons.headphones,
      'plant': LucideIcons.leaf,
      'tent': LucideIcons.tent,
      'terminal': LucideIcons.terminal,
      'campfire': LucideIcons.flame,
      'newspaper': LucideIcons.newspaper,
      'waves': LucideIcons.waves,
      'brain': LucideIcons.brain,
      'translate': LucideIcons.languages,
      'boat': LucideIcons.ship,
      'bike': LucideIcons.bike,
      'hammer': LucideIcons.hammer,
      'medicine': LucideIcons.pill,
      'palette': LucideIcons.palette,
      'mic': LucideIcons.mic,
      'chat': LucideIcons.messageCircle,
      'laptop': LucideIcons.laptop,
      'graduation': LucideIcons.graduationCap,
      'bank': LucideIcons.landmark,
      'gift': LucideIcons.gift,
      'microscope': LucideIcons.microscope,
      'confetti': LucideIcons.partyPopper,
    },
  ),
  const HabitIconCategory(
    name: 'Sports',
    icons: {
      'pulse': LucideIcons.activity, // Default icon
      'medal': LucideIcons.medal,
      'sailboat': LucideIcons.sailboat,
      'heart': LucideIcons.heart,
      'basketball': LucideIcons.circle,
      'walking': LucideIcons.footprints,
      'running': LucideIcons.personStanding,
      'shoe': LucideIcons.footprints,
      'tennis': LucideIcons.circle,
      'volleyball': LucideIcons.aperture,
      'football': LucideIcons.circle,
      'swimming': LucideIcons.waves,
    },
  ),
  const HabitIconCategory(
    name: 'Food and Beverages',
    icons: {
      'apple': LucideIcons.apple,
      'carrot': LucideIcons.carrot,
      'bowl': LucideIcons.coffee,
      'cake': LucideIcons.cake,
      'cookie': LucideIcons.cookie,
      'pizza': LucideIcons.pizza,
      'burger': LucideIcons.beef,
      'drink': LucideIcons.glassWater,
      'coffee': LucideIcons.coffee,
      'coffee_bean': LucideIcons.coffee,
      'wine': LucideIcons.wine,
      'martini': LucideIcons.glassWater,
      'beer': LucideIcons.beer,
    },
  ),
  const HabitIconCategory(
    name: 'Art',
    icons: {
      'image': LucideIcons.image,
      'paint_roller': LucideIcons.paintbrush2,
      'camera': LucideIcons.camera,
      'paintbrush': LucideIcons.paintbrush,
      'pencil': LucideIcons.pencil,
      'pen': LucideIcons.penTool,
      'music_note': LucideIcons.music,
      'film': LucideIcons.film,
      'video_camera': LucideIcons.video,
      'clapperboard': LucideIcons.clapperboard,
      'aperture': LucideIcons.aperture,
      'guitar': LucideIcons.music,
      'piano': LucideIcons.music,
    },
  ),
  const HabitIconCategory(
    name: 'Financial',
    icons: {
      'cash': LucideIcons.banknote,
      'coins': LucideIcons.coins,
      'credit_card': LucideIcons.creditCard,
      'receipt': LucideIcons.receipt,
      'currency_eur': LucideIcons.euro,
      'currency_dollar': LucideIcons.dollarSign,
      'wallet': LucideIcons.wallet,
      'currency_gbp': LucideIcons.poundSterling,
      'currency_btc': LucideIcons.bitcoin,
      'chart_up': LucideIcons.trendingUp,
      'piggy_bank': LucideIcons.piggyBank,
      'pie_chart': LucideIcons.pieChart,
      'scales': LucideIcons.scale,
    },
  ),
  const HabitIconCategory(
    name: 'Miscellaneous',
    icons: {
      'alarm': LucideIcons.alarmClock,
      'alert': LucideIcons.alertTriangle,
      'smile': LucideIcons.smile,
      'sad': LucideIcons.frown,
      'star': LucideIcons.star,
      'list': LucideIcons.list,
      'bell': LucideIcons.bell,
      'cube': LucideIcons.box,
      'trash': LucideIcons.trash,
      'building': LucideIcons.building,
      'calendar': LucideIcons.calendar,
      'car': LucideIcons.car,
      'truck': LucideIcons.truck,
      'check_circle': LucideIcons.checkCircle,
      'clock': LucideIcons.clock,
      'cloud': LucideIcons.cloud,
      'sun': LucideIcons.sun,
      'moon': LucideIcons.moon,
      'globe': LucideIcons.globe,
      'leaf': LucideIcons.leaf,
      'dog': LucideIcons.dog,
      'cat': LucideIcons.cat,
      'gear': LucideIcons.settings,
      'diamond': LucideIcons.gem,
      'eye': LucideIcons.eye,
      'document': LucideIcons.file,
      'lock': LucideIcons.lock,
      'rocket': LucideIcons.rocket,
      'save': LucideIcons.save,
      'send': LucideIcons.send,
    },
  ),
];

// Flat map for quick lookup by icon string ID
final Map<String, IconData> allHabitIcons = {
  for (var category in habitIconCategories) ...category.icons,
};

IconData getHabitIcon(String name) {
  // Try to find it in our comprehensive list
  if (allHabitIcons.containsKey(name)) {
    return allHabitIcons[name]!;
  }
  
  // Fallback for older saved data matching standard Material Icons
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
    default: return LucideIcons.activity; // The requested default 'pulse/activity' icon
  }
}
