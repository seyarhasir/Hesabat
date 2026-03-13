import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppButtonVariant {
  primary,
  secondary,
  success,
  danger,
  outline,
  ghost,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final IconData? icon;
  final double? height;
  final EdgeInsets? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    double buttonHeight;
    double fontSize;
    double iconSize;
    EdgeInsets buttonPadding;

    switch (size) {
      case AppButtonSize.small:
        buttonHeight = 36;
        fontSize = 13;
        iconSize = 16;
        buttonPadding = const EdgeInsets.symmetric(horizontal: 16);
        break;
      case AppButtonSize.medium:
        buttonHeight = 48;
        fontSize = 15;
        iconSize = 20;
        buttonPadding = const EdgeInsets.symmetric(horizontal: 24);
        break;
      case AppButtonSize.large:
        buttonHeight = 56;
        fontSize = 17;
        iconSize = 24;
        buttonPadding = const EdgeInsets.symmetric(horizontal: 32);
        break;
    }

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: iconSize,
            height: iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(_loadingColor(cs)),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: iconSize),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
        ),
      ],
    );

    final button = ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: _style(cs, buttonPadding),
      child: buttonChild,
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, height: height ?? buttonHeight, child: button);
    }
    return SizedBox(height: height ?? buttonHeight, child: button);
  }

  ButtonStyle _style(ColorScheme cs, EdgeInsets defaultPadding) {
    final base = ElevatedButton.styleFrom(
      elevation: 0,
      padding: padding ?? defaultPadding,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );

    switch (variant) {
      case AppButtonVariant.primary:
        return base.copyWith(
          backgroundColor: WidgetStateProperty.all(cs.primary),
          foregroundColor: WidgetStateProperty.all(cs.onPrimary),
        );
      case AppButtonVariant.secondary:
        return base.copyWith(
          backgroundColor: WidgetStateProperty.all(cs.surface),
          foregroundColor: WidgetStateProperty.all(cs.onSurface),
          side: WidgetStateProperty.all(BorderSide(color: cs.outline)),
        );
      case AppButtonVariant.success:
        return base.copyWith(
          backgroundColor: WidgetStateProperty.all(AppColors.success),
          foregroundColor: WidgetStateProperty.all(Colors.white),
        );
      case AppButtonVariant.danger:
        return base.copyWith(
          backgroundColor: WidgetStateProperty.all(cs.error),
          foregroundColor: WidgetStateProperty.all(cs.onError),
        );
      case AppButtonVariant.outline:
        return base.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(cs.primary),
          side: WidgetStateProperty.all(BorderSide(color: cs.outline)),
        );
      case AppButtonVariant.ghost:
        return base.copyWith(
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(cs.primary),
        );
    }
  }

  Color _loadingColor(ColorScheme cs) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.success:
      case AppButtonVariant.danger:
        return Colors.white;
      case AppButtonVariant.secondary:
      case AppButtonVariant.outline:
      case AppButtonVariant.ghost:
        return cs.primary;
    }
  }
}
