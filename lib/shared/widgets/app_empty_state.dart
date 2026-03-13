import 'package:flutter/material.dart';
import '../theme/app_layout.dart';
import 'app_button.dart';

/// A unified empty state component to replace duplicated implementations across the app.
class AppEmptyState extends StatelessWidget {
  final String title;
  final String? description;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? action;
  final bool isLarge;

  const AppEmptyState({
    super.key,
    required this.title,
    this.description,
    required this.icon,
    this.actionLabel,
    this.onAction,
    this.action,
    this.isLarge = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isLarge ? AppSpacing.xl : AppSpacing.l),
              decoration: BoxDecoration(
                color: cs.onSurface.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isLarge ? 64 : 48,
                color: cs.onSurface.withOpacity(0.3),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: cs.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ] else if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                text: actionLabel!,
                onPressed: onAction!,
                icon: Icons.add,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
