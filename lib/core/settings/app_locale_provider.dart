import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppLocaleNotifier extends StateNotifier<Locale> {
	AppLocaleNotifier() : super(const Locale('en'));

	static const _storage = FlutterSecureStorage();
	static const _localeKey = 'app_locale_code';

	Future<void> loadSavedLocale() async {
		final savedCode = await _storage.read(key: _localeKey);
		if (savedCode == null || savedCode.isEmpty) return;
		state = Locale(savedCode);
	}

	Future<void> setLocale(Locale locale) async {
		state = locale;
		await _storage.write(key: _localeKey, value: locale.languageCode);
	}
}

final appSettingsLocaleProvider = StateNotifierProvider<AppLocaleNotifier, Locale>((ref) {
	return AppLocaleNotifier();
});
