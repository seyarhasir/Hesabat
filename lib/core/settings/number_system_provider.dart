import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum NumberSystem { english, farsi }

class NumberSystemNotifier extends StateNotifier<NumberSystem> {
  NumberSystemNotifier() : super(NumberSystem.english);

  static const _storage = FlutterSecureStorage();
  static const _numberSystemKey = 'app_number_system';

  Future<void> loadSavedNumberSystem() async {
    try {
      final saved = await _storage.read(key: _numberSystemKey).timeout(const Duration(seconds: 2));
      if (saved == 'farsi') {
        state = NumberSystem.farsi;
        return;
      }
      state = NumberSystem.english;
    } catch (e) {
      debugPrint('Failed to load saved number system: $e');
    }
  }

  Future<void> setNumberSystem(NumberSystem system) async {
    state = system;
    await _storage.write(
      key: _numberSystemKey,
      value: system == NumberSystem.farsi ? 'farsi' : 'english',
    );
  }
}

final appNumberSystemProvider = StateNotifierProvider<NumberSystemNotifier, NumberSystem>((ref) {
  return NumberSystemNotifier();
});
