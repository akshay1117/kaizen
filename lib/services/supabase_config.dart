import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'https://eblounriefctpnsmxtqz.supabase.co';
  static const String publishableKey = 'sb_publishable_BoLi65Nyh6hAK9zGBfqZnw_r9BKXc8J';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      publishableKey: publishableKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
