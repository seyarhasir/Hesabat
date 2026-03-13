import 'package:flutter/material.dart';

/// Light and dark color tokens derived from the design system.
/// Clean, flat, no gradients, no shadows.
class AppColors {
  AppColors._();

  // ── Light theme ──────────────────────────────────────────────
  static const light = _LightColors();

  // ── Dark theme ───────────────────────────────────────────────
  static const dark = _DarkColors();

  // ── Semantic (theme-independent) ─────────────────────────────
  static const success = Color(0xFF1A7A4A);
  static const warning = Color(0xFFC0580A);
  static const danger = Color(0xFFB91C1C);

  // Chart palette
  static const chart1 = Color(0xFF1A56A0);
  static const chart2 = Color(0xFF1A7A4A);
  static const chart3 = Color(0xFFC0580A);
  static const chart4 = Color(0xFFB91C1C);
  static const chart5 = Color(0xFF64748B);

  // Currency colors
  static const afn = Color(0xFF1A56A0);
  static const usd = Color(0xFF1A7A4A);
  static const pkr = Color(0xFFB91C1C);

  // Debt status colors
  static const debtCurrent = success;
  static const debtWarning = warning;
  static const debtOverdue = danger;
}

class _LightColors {
  const _LightColors();

  Color get primary => const Color(0xFF1A56A0);
  Color get primaryForeground => const Color(0xFFFFFFFF);
  Color get background => const Color(0xFFF8FAFC);
  Color get foreground => const Color(0xFF1A1A2E);
  Color get card => const Color(0xFFFFFFFF);
  Color get cardForeground => const Color(0xFF1A1A2E);
  Color get muted => const Color(0xFFF1F5F9);
  Color get mutedForeground => const Color(0xFF64748B);
  Color get accent => const Color(0xFFE3ECF6);
  Color get accentForeground => const Color(0xFF1A56A0);
  Color get border => const Color(0xFFE2E8F0);
  Color get input => const Color(0xFFFFFFFF);
  Color get ring => const Color(0xFF1A56A0);
  Color get secondary => const Color(0xFF1A1A2E);
  Color get secondaryForeground => const Color(0xFFFFFFFF);
  Color get destructive => const Color(0xFFB91C1C);
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  Color get popover => const Color(0xFFFFFFFF);
  Color get popoverForeground => const Color(0xFF1A1A2E);
}

class _DarkColors {
  const _DarkColors();

  Color get primary => const Color(0xFF60A5FA); // Lighter blue for dark mode
  Color get primaryForeground => const Color(0xFFFFFFFF);
  Color get background => const Color(0xFF0F172A);
  Color get foreground => const Color(0xFFF8FAFC);
  Color get card => const Color(0xFF1E293B);
  Color get cardForeground => const Color(0xFFF8FAFC);
  Color get muted => const Color(0xFF334155);
  Color get mutedForeground => const Color(0xFF94A3B8);
  Color get accent => const Color(0xFF1E293B);
  Color get accentForeground => const Color(0xFF60A5FA);
  Color get border => const Color(0xFF334155);
  Color get input => const Color(0xFF1E293B);
  Color get ring => const Color(0xFF60A5FA);
  Color get secondary => const Color(0xFFF8FAFC);
  Color get secondaryForeground => const Color(0xFF1A1A2E);
  Color get destructive => const Color(0xFFEF4444);
  Color get destructiveForeground => const Color(0xFFFFFFFF);
  Color get popover => const Color(0xFF1E293B);
  Color get popoverForeground => const Color(0xFFF8FAFC);
}
