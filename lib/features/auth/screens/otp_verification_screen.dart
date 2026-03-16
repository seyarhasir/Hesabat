import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../shared/theme/app_layout.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _passcodeController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePasscode = true;

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtp() async {
    final passcode = _passcodeController.text.trim();
    if (passcode.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passcode must be 10 characters.')),
      );
      return;
    }

    setState(() => _isLoading = true);
    // ISSUE-03 fix: verifyOtp now returns the shop profile
    final profile = await ref.read(authProvider.notifier).verifyOtp(
      widget.phone,
      passcode,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (ref.read(authProvider).isAuthenticated) {
        // ISSUE-03 fix: Set currentShopIdProvider from the returned profile
        if (profile != null) {
          ref.read(currentShopIdProvider.notifier).state = profile.shopId;
        }

        // Determine if the user has a shop (either from profile or local onboarding flag)
        bool hasShop = profile != null;
        if (!hasShop) {
          // ISSUE-10: Check local onboarding_completed flag
          hasShop = await ShopProfileService.isOnboardingCompleted();
        }

        Navigator.pushNamedAndRemoveUntil(
          context,
          hasShop ? '/home' : '/onboarding/shop-setup',
          (route) => false,
        );
      } else {
        final err = ref.read(authProvider).error;
        _passcodeController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(err ?? 'Invalid passcode. Try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: cs.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primary.withOpacity(0.08),
              cs.surface,
              cs.secondary.withOpacity(0.04),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom top bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_rounded),
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: cs.surface,
                        foregroundColor: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Icon/Logo placeholder
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.lock_person_rounded, size: 32, color: cs.primary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Enter Passcode',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Text(
                            'For ',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: cs.onSurface.withOpacity(0.6),
                            ),
                          ),
                          Text(
                            widget.phone,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: cs.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 48),

                      // Passcode Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              '10-Character Passcode',
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: cs.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: cs.outline.withOpacity(0.2),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.primary.withOpacity(0.03),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _passcodeController,
                              autofocus: true,
                              enabled: !_isLoading,
                              maxLength: 10,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              obscureText: _obscurePasscode,
                              autocorrect: false,
                              enableSuggestions: false,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                LengthLimitingTextInputFormatter(10),
                              ],
                              onSubmitted: (_) => _verifyOtp(),
                              style: theme.textTheme.titleMedium?.copyWith(
                                letterSpacing: 4,
                                fontWeight: FontWeight.bold,
                                color: cs.onSurface,
                              ),
                              decoration: InputDecoration(
                                hintText: '••••••••••',
                                hintStyle: TextStyle(
                                  color: cs.onSurface.withOpacity(0.2),
                                  letterSpacing: 4,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                                counterText: '',
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: IconButton(
                                    onPressed: _isLoading
                                        ? null
                                        : () => setState(() => _obscurePasscode = !_obscurePasscode),
                                    icon: Icon(
                                      _obscurePasscode ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                      color: cs.primary.withOpacity(0.6),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Helping info
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cs.primary.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: cs.primary.withOpacity(0.05)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.help_outline_rounded, color: cs.primary.withOpacity(0.5), size: 20),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                "Your passcode is a unique 10-character code provided by your administrator.",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withOpacity(0.6),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: AppButton(
                    text: 'Verify & Sign In',
                    onPressed: _isLoading ? null : _verifyOtp,
                    isLoading: _isLoading,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
