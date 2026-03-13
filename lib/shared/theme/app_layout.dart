import 'package:flutter/material.dart';

/// Standard spacing tokens for the app.
class AppSpacing {
  AppSpacing._();

  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Semantic spacing
  static const double cardPadding = l;
  static const double screenPadding = l;
  static const double elementGap = m;
  static const double sectionGap = xl;
}

/// Standard border radius tokens.
class AppRadius {
  AppRadius._();

  static const double s = 8.0;
  static const double m = 12.0;
  static const double l = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;

  static final BorderRadius small = BorderRadius.circular(s);
  static final BorderRadius medium = BorderRadius.circular(m);
  static final BorderRadius large = BorderRadius.circular(l);
  static final BorderRadius xLarge = BorderRadius.circular(xl);
  static final BorderRadius xxLarge = BorderRadius.circular(xxl);
}
