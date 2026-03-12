import 'package:flutter/material.dart';

class AppColors {
  // Primary palette
  static const primary = Color(0xFF1A56A0); // Blue — primary actions
  static const primaryLight = Color(0xFF3B82F6);
  static const primaryDark = Color(0xFF1E3A8A);
  
  // Semantic colors
  static const success = Color(0xFF1A7A4A); // Green — payments, positive
  static const warning = Color(0xFFC0580A); // Orange — low stock, due debts
  static const danger = Color(0xFFB91C1C); // Red — overdue, errors
  
  // Background colors
  static const background = Color(0xFFF8FAFC); // App background
  static const surface = Color(0xFFFFFFFF); // Cards
  static const surfaceVariant = Color(0xFFF1F5F9);
  
  // Text colors
  static const textPrimary = Color(0xFF1A1A2E); // Body text
  static const textSecondary = Color(0xFF64748B); // Labels
  static const textDisabled = Color(0xFF94A3B8);
  
  // Border colors
  static const border = Color(0xFFE2E8F0);
  static const borderLight = Color(0xFFF1F5F9);
  
  // Debt status colors
  static const debtCurrent = success; // < 7 days
  static const debtWarning = warning; // 7-30 days
  static const debtOverdue = danger; // > 30 days
  
  // Currency colors
  static const afn = Color(0xFF1A56A0);
  static const usd = Color(0xFF16A34A);
  static const pkr = Color(0xFFDC2626);
}
