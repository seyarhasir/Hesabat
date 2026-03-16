import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  final String supabaseUrl;
  final String supabaseAnonKey;

  const EnvConfig({
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  static Future<EnvConfig> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Optional; values may come from --dart-define.
    }

    final url = _readValue('SUPABASE_URL');
    final anon = _readValue('SUPABASE_ANON_KEY');

    if (url == null || url.isEmpty) {
      throw Exception('Missing SUPABASE_URL. Provide via .env or --dart-define.');
    }

    if (anon == null || anon.isEmpty) {
      throw Exception('Missing SUPABASE_ANON_KEY. Provide via .env or --dart-define.');
    }

    return EnvConfig(
      supabaseUrl: url,
      supabaseAnonKey: anon,
    );
  }

  static String? _readValue(String key) {
    String? envValue;
    try {
      envValue = dotenv.env[key]?.trim();
    } catch (_) {
      envValue = null;
    }
    if (envValue != null && envValue.isNotEmpty) return envValue;

    const fromDefineUrl = String.fromEnvironment('SUPABASE_URL');
    const fromDefineAnon = String.fromEnvironment('SUPABASE_ANON_KEY');

    switch (key) {
      case 'SUPABASE_URL':
        return fromDefineUrl.isNotEmpty ? fromDefineUrl : null;
      case 'SUPABASE_ANON_KEY':
        return fromDefineAnon.isNotEmpty ? fromDefineAnon : null;
      default:
        return null;
    }
  }
}
