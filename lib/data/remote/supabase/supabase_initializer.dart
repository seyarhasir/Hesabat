import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/config/env.dart';

class SupabaseInitializer {
  static bool _initialized = false;

  static Future<void> initialize(EnvConfig env) async {
    if (_initialized) return;

    await Supabase.initialize(
      url: env.supabaseUrl,
      anonKey: env.supabaseAnonKey,
    );

    _initialized = true;
  }
}
