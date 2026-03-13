import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

/// Calendar system types
enum CalendarType { gregorian, persian }

class DateFormatter {
  /// Format date based on calendar type
  static String formatDate(DateTime date, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    if (calendar == CalendarType.persian) {
      final jalali = Jalali.fromDateTime(date);
      return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')}';
    }
    // Gregorian calendar
    final formatter = DateFormat('yyyy/MM/dd', locale);
    return formatter.format(date);
  }
  
  /// Format date and time based on calendar type
  static String formatDateTime(DateTime date, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    if (calendar == CalendarType.persian) {
      final jalali = Jalali.fromDateTime(date);
      final timeStr = DateFormat('HH:mm').format(date);
      return '${jalali.year}/${jalali.month.toString().padLeft(2, '0')}/${jalali.day.toString().padLeft(2, '0')} $timeStr';
    }
    // Gregorian calendar
    final formatter = DateFormat('yyyy/MM/dd HH:mm', locale);
    return formatter.format(date);
  }
  
  /// Format time only (same for both calendars)
  static String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm');
    return formatter.format(date);
  }
  
  /// Format relative time (same for both calendars - based on time difference)
  static String formatRelative(DateTime date, {String locale = 'fa', CalendarType calendar = CalendarType.gregorian}) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes < 5) {
          if (locale == 'en') return 'Just now';
          if (locale == 'ps') return 'همدا اوس';
          return 'همین الان';
        }
        if (locale == 'en') return '${difference.inMinutes} minutes ago';
        if (locale == 'ps') return '${difference.inMinutes} دقیقې مخکې';
        return '${difference.inMinutes} دقیقه پیش';
      }
      if (locale == 'en') return '${difference.inHours} hours ago';
      if (locale == 'ps') return '${difference.inHours} ساعته مخکې';
      return '${difference.inHours} ساعت پیش';
    } else if (difference.inDays == 1) {
      if (locale == 'en') return 'Yesterday';
      if (locale == 'ps') return 'پرون';
      return 'دیروز';
    } else if (difference.inDays < 7) {
      if (locale == 'en') return '${difference.inDays} days ago';
      if (locale == 'ps') return '${difference.inDays} ورځې مخکې';
      return '${difference.inDays} روز پیش';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      if (locale == 'en') return '$weeks weeks ago';
      if (locale == 'ps') return '$weeks اونۍ مخکې';
      return '$weeks هفته پیش';
    } else {
      return formatDate(date, calendar: calendar, locale: locale);
    }
  }
  
  /// Format for display with null check
  static String formatForDisplay(DateTime? date, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    if (date == null) return '-';
    return formatDate(date, calendar: calendar, locale: locale);
  }
  
  /// Get month name based on calendar type
  static String getMonthName(int month, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    if (calendar == CalendarType.persian) {
      final persianMonths = locale == 'en'
          ? ['Farvardin', 'Ordibehesht', 'Khordad', 'Tir', 'Mordad', 'Shahrivar', 'Mehr', 'Aban', 'Azar', 'Dey', 'Bahman', 'Esfand']
          : locale == 'ps'
              ? ['وری', 'غویی', 'غبرګولی', 'چنګاښ', 'زمری', 'وږی', 'تله', 'لړم', 'ليندۍ', 'مرغومی', 'سلواغه', 'کب']
              : ['فروردین', 'اردیبهشت', 'خرداد', 'تیر', 'مرداد', 'شهریور', 'مهر', 'آبان', 'آذر', 'دی', 'بهمن', 'اسفند'];
      return persianMonths[month - 1];
    }
    // Gregorian months
    final formatter = DateFormat('MMMM', locale);
    final date = DateTime(2024, month, 1);
    return formatter.format(date);
  }
  
  /// Get day of week name based on calendar type
  static String getDayOfWeekName(DateTime date, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    if (calendar == CalendarType.persian) {
      final jalali = Jalali.fromDateTime(date);
      final persianWeekdays = locale == 'en'
          ? ['Shanbeh', 'Yekshanbeh', 'Doshanbeh', 'Seshanbeh', 'Chaharshanbeh', 'Panjshanbeh', "Jom'eh"]
          : locale == 'ps'
              ? ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه']
              : ['شنبه', 'یکشنبه', 'دوشنبه', 'سه‌شنبه', 'چهارشنبه', 'پنجشنبه', 'جمعه'];
      return persianWeekdays[jalali.weekDay - 1];
    }
    // Gregorian
    final formatter = DateFormat('EEEE', locale);
    return formatter.format(date);
  }
  
  /// Format date range for display
  static String formatDateRange(DateTime start, DateTime end, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    final startStr = formatDate(start, calendar: calendar, locale: locale);
    final endStr = formatDate(end, calendar: calendar, locale: locale);
    return '$startStr → $endStr';
  }

  /// Get month name from a concrete date (handles Jalali month extraction when Persian calendar is selected)
  static String getMonthNameForDate(DateTime date, {CalendarType calendar = CalendarType.gregorian, String locale = 'fa'}) {
    if (calendar == CalendarType.persian) {
      final jm = Jalali.fromDateTime(date).month;
      return getMonthName(jm, calendar: calendar, locale: locale);
    }
    return getMonthName(date.month, calendar: calendar, locale: locale);
  }
}
