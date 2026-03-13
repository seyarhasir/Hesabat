import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

const _radius = 20.0;

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _build(AppColors.light, Brightness.light);
  static ThemeData get darkTheme => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(dynamic c, Brightness brightness) {
    final isLight = brightness == Brightness.light;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: c.primary,
      onPrimary: c.primaryForeground,
      secondary: c.accent,
      onSecondary: c.accentForeground,
      error: c.destructive,
      onError: c.destructiveForeground,
      surface: c.card,
      onSurface: c.foreground,
      surfaceContainerHighest: c.muted,
      outline: c.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: c.background,
      dividerColor: c.border,
      fontFamily: 'Vazirmatn',

      // AppBar — flat, surface-level
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: c.background,
        foregroundColor: c.foreground,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isLight
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: c.foreground,
        ),
      ),

      // Card — flat, border only
      cardTheme: CardThemeData(
        elevation: 0,
        color: c.card,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: c.border),
        ),
        margin: EdgeInsets.zero,
      ),

      // Buttons — flat
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: c.primary,
          foregroundColor: c.primaryForeground,
          disabledBackgroundColor: c.muted,
          disabledForegroundColor: c.mutedForeground.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: c.primary,
          foregroundColor: c.primaryForeground,
          disabledBackgroundColor: c.muted,
          disabledForegroundColor: c.mutedForeground.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(0, 48),
          side: BorderSide(color: c.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input — flat
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.input,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: c.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: c.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(_radius),
          borderSide: BorderSide(color: c.destructive, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: TextStyle(color: c.mutedForeground.withOpacity(0.5)),
        labelStyle: TextStyle(color: c.mutedForeground),
      ),

      // Text
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: c.foreground),
        displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: c.foreground),
        displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: c.foreground),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: c.foreground),
        titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: c.foreground),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: c.foreground),
        bodyLarge: TextStyle(fontSize: 16, color: c.foreground),
        bodyMedium: TextStyle(fontSize: 14, color: c.mutedForeground),
        bodySmall: TextStyle(fontSize: 12, color: c.mutedForeground),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: c.primary),
      ),

      dividerTheme: DividerThemeData(color: c.border, thickness: 1, space: 1),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
      ),

      // Bottom nav — flat
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.card,
        selectedItemColor: c.primary,
        unselectedItemColor: c.mutedForeground,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.card,
        indicatorColor: c.accent,
        elevation: 0,
        height: 64,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: c.primary);
          }
          return TextStyle(fontSize: 12, color: c.mutedForeground);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: c.primary, size: 24);
          }
          return IconThemeData(color: c.mutedForeground, size: 24);
        }),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.primary,
        foregroundColor: c.primaryForeground,
        elevation: 0,
        hoverElevation: 0,
        focusElevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: c.card,
        selectedColor: c.accent,
        disabledColor: c.muted,
        labelStyle: TextStyle(color: c.foreground, fontSize: 14),
        secondaryLabelStyle: TextStyle(color: c.primary),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        side: BorderSide(color: c.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: c.popover,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_radius),
          side: BorderSide(color: c.border),
        ),
      ),

      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.popover,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.secondary,
        contentTextStyle: TextStyle(color: c.secondaryForeground),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_radius)),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.primary,
        linearTrackColor: c.muted,
      ),
    );
  }
}
