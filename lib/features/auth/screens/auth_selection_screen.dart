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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Logo
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Icon(Icons.store_rounded, size: 40, color: cs.onPrimary),
              ),
              const SizedBox(height: 24),

              Text(
                '\u062D\u0633\u0627\u0628\u0627\u062A',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Smart Shop Management',
                style: theme.textTheme.bodyMedium,
              ),

              const Spacer(flex: 2),

              // Sign In
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Sign In',
                  icon: Icons.login_rounded,
                  onPressed: () => Navigator.pushNamed(context, '/auth/phone'),
                  variant: AppButtonVariant.primary,
                ),
              ),
              const SizedBox(height: 12),

              // Demo
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Try Demo',
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

              const SizedBox(height: 24),

              // Demo limits info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.secondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outline),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo limits',
                      style: theme.textTheme.labelLarge?.copyWith(color: cs.onSurface),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '10 products  \u2022  5 sales  \u2022  No sync  \u2022  No WhatsApp',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              Text('Need an account? Contact sales', style: theme.textTheme.bodySmall),
              const SizedBox(height: 4),
              Text('+93 70 000 0000', style: theme.textTheme.labelLarge),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
