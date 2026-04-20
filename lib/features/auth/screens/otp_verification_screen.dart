import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/settings/shop_profile_service.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_button.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _passcodeController = TextEditingController();
  final _passcodeFocusNode = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _passcodeController.dispose();
    _passcodeFocusNode.dispose();
    super.dispose();
  }

  String get _sanitizedPasscode {
    final value = _passcodeController.text.replaceAll(RegExp(r'[^A-Za-z0-9]'), '');
    return value.length <= 10 ? value : value.substring(0, 10);
  }

  Widget _buildPasscodeBoxes(ThemeData theme, ColorScheme cs) {
    final passcode = _sanitizedPasscode;

    return GestureDetector(
      onTap: () => _passcodeFocusNode.requestFocus(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(10, (index) {
                final hasValue = index < passcode.length;
                final isActive = passcode.length == index && !_isLoading;
                final char = hasValue ? passcode[index] : '';

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  width: 30,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: cs.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isActive
                          ? cs.primary
                          : hasValue
                              ? cs.primary.withOpacity(0.45)
                              : cs.outline.withOpacity(0.28),
                      width: isActive ? 2 : 1.4,
                    ),
                  ),
                  child: Text(
                    char,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${passcode.length}/10',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.onSurface.withOpacity(0.55),
            ),
          ),
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 0,
              width: 0,
              child: TextField(
                controller: _passcodeController,
                focusNode: _passcodeFocusNode,
                autofocus: true,
                enabled: !_isLoading,
                maxLength: 10,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                enableSuggestions: false,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _verifyOtp(),
                decoration: const InputDecoration(counterText: ''),
              ),
            ),
          ),
        ],
      ),
    );
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
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                              child: _buildPasscodeBoxes(theme, cs),
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
