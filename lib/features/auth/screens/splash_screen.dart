import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/shop_profile_service.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    final authState = ref.read(authProvider);
    ShopProfile? profile = await ShopProfileService.load();

    // ISSUE-06 fix: If authenticated but no local profile, try fetching from cloud
    if (profile == null && authState.isAuthenticated) {
      try {
        profile = await ShopProfileService.fetchFromCloud(Supabase.instance.client);
      } catch (e) {
        print('HESABAT: Cloud fetch on splash failed: $e');
      }
    }

    if (profile != null) {
      ref.read(currentShopIdProvider.notifier).state = profile.shopId;
    }

    if (authState.isGuest || authState.isAuthenticated) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // ISSUE-15 fix: Check if language is already set (returning user)
      final hasLanguage = await _hasLanguagePreference();
      Navigator.pushReplacementNamed(
        context,
        hasLanguage ? '/auth/phone' : '/onboarding/language',
      );
    }
  }

  /// ISSUE-15: Check if user has previously selected a language
  Future<bool> _hasLanguagePreference() async {
    try {
      const storage = FlutterSecureStorage();
      final code = await storage.read(key: 'app_locale_code');
      return code != null && code.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('HESABAT: SplashScreen build');
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(Icons.store_rounded, size: 48, color: cs.onPrimary),
            ),
            const SizedBox(height: 32),

            Text(
              '\u062D\u0633\u0627\u0628\u0627\u062A',
              style: theme.textTheme.displayMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Hesabat',
              style: theme.textTheme.titleLarge?.copyWith(
                color: cs.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Smart Shop Management',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 48),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: cs.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
