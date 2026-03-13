import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Calendar system options for the app
enum CalendarSystem { gregorian, persian }

/// Notifier for managing calendar system preference
class CalendarSystemNotifier extends StateNotifier<CalendarSystem> {
  CalendarSystemNotifier() : super(CalendarSystem.gregorian);

  static const _storage = FlutterSecureStorage();
  static const _calendarSystemKey = 'app_calendar_system';

  /// Load saved calendar system from secure storage
  Future<void> loadSavedCalendarSystem() async {
    final saved = await _storage.read(key: _calendarSystemKey);
    if (saved == 'persian') {
      state = CalendarSystem.persian;
      return;
    }
    state = CalendarSystem.gregorian;
  }

  /// Set calendar system and persist to storage
  Future<void> setCalendarSystem(CalendarSystem system) async {
    state = system;
    await _storage.write(
      key: _calendarSystemKey,
      value: system == CalendarSystem.persian ? 'persian' : 'gregorian',
    );
  }
}

/// Provider for calendar system setting
final appCalendarSystemProvider = StateNotifierProvider<CalendarSystemNotifier, CalendarSystem>((ref) {
  return CalendarSystemNotifier();
});
