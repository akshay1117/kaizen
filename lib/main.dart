import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kaizen/services/app.dart';
import 'package:kaizen/services/supabase_config.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

late final SharedPreferences globalPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globalPrefs = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  await LiquidGlassWidgets.initialize();
  await SupabaseConfig.initialize();
  runApp(const ProviderScope(child: KaizenApp()));
}