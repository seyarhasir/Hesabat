import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../shared/widgets/app_button.dart';

class AuthSelectionScreen extends ConsumerWidget {
  const AuthSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: Container(
        decoration: BoxDecoration(
          color: cs.surface,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 3),

                // Premium Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: cs.primary,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: cs.primary.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(Icons.store_rounded, size: 48, color: cs.onPrimary),
                ),
                const SizedBox(height: 32),

                Text(
                  '\u062D\u0633\u0627\u0628\u0627\u062A',
                  style: theme.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: cs.onSurface,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Smart Shop Management',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: cs.onSurface.withOpacity(0.5),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Spacer(flex: 2),

                // Sign In
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: AppButton(
                    text: 'Sign In',
                    icon: Icons.login_rounded,
                    onPressed: () => Navigator.pushReplacementNamed(context, '/auth/phone'),
                    variant: AppButtonVariant.primary,
                  ),
                ),
                const SizedBox(height: 16),

                // Demo
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: AppButton(
                    text: 'Try Demo Mode',
                    icon: Icons.play_circle_outline_rounded,
                    onPressed: () async {
                      await ref.read(authProvider.notifier).activateGuestMode();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/home');
                      }
                    },
                    variant: AppButtonVariant.outline,
                  ),
                ),

                const SizedBox(height: 32),

                // Demo limits info (Glass-like)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: cs.surface.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: cs.outline.withOpacity(0.1)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info_outline_rounded, size: 16, color: cs.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Demo Limits',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: cs.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '10 products  \u2022  5 sales  \u2022  No sync  \u2022  No WhatsApp',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Column(
                  children: [
                    Text(
                      'Need an account? Contact Sales',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '+93 70 000 0000',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
