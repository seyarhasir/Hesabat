import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppThemeModeNotifier extends StateNotifier<ThemeMode> {
  AppThemeModeNotifier() : super(ThemeMode.system);

  static const _storage = FlutterSecureStorage();
  static const _themeModeKey = 'app_theme_mode';

  Future<void> loadSavedThemeMode() async {
    final saved = await _storage.read(key: _themeModeKey);
    if (saved == null || saved.isEmpty) return;

    switch (saved) {
      case 'light':
        state = ThemeMode.light;
        break;
      case 'dark':
        state = ThemeMode.dark;
        break;
      default:
        state = ThemeMode.system;
        break;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;

    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };

    await _storage.write(key: _themeModeKey, value: value);
  }
}

final appThemeModeProvider = StateNotifierProvider<AppThemeModeNotifier, ThemeMode>((ref) {
  return AppThemeModeNotifier();
});
