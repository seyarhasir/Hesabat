import 'package:flutter/material.dart';
import '../theme/app_layout.dart';

/// A shared numeric keypad component to replace duplicated code in OTP and Payment screens.
class AppNumericKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspace;
  final VoidCallback? onDone;
  final String? actionLabel;

  const AppNumericKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspace,
    this.onDone,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(children: [_key('1', cs, theme), _key('2', cs, theme), _key('3', cs, theme)]),
        Row(children: [_key('4', cs, theme), _key('5', cs, theme), _key('6', cs, theme)]),
        Row(children: [_key('7', cs, theme), _key('8', cs, theme), _key('9', cs, theme)]),
        Row(
          children: [
            _actionKey(
              onDone != null ? (actionLabel ?? 'Confirm') : null,
              onDone,
              cs,
              theme,
              isAction: true,
            ),
            _key('0', cs, theme),
            _actionKey(null, onBackspace, cs, theme, icon: Icons.backspace_outlined),
          ],
        ),
      ],
    );
  }

  Widget _key(String digit, ColorScheme cs, ThemeData theme) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Material(
          color: cs.surface,
          borderRadius: AppRadius.large,
          child: InkWell(
            onTap: () => onDigitPressed(digit),
            borderRadius: AppRadius.large,
            child: SizedBox(
              height: 60,
              child: Center(
                child: Text(
                  digit,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionKey(
    String? label,
    VoidCallback? onTap,
    ColorScheme cs,
    ThemeData theme, {
    IconData? icon,
    bool isAction = false,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Material(
          color: isAction && onTap != null ? cs.primary : cs.surface,
          borderRadius: AppRadius.large,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.large,
            child: SizedBox(
              height: 60,
              child: Center(
                child: icon != null
                    ? Icon(icon, size: 24, color: cs.onSurface)
                    : label != null
                        ? Text(
                            label,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: isAction ? cs.onPrimary : cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const SizedBox(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
