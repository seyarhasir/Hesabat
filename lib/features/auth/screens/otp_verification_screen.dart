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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.l),
              Text('Enter Passcode', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.s),
              Text(
                'For ${widget.phone}',
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              TextField(
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
                style: theme.textTheme.titleLarge?.copyWith(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: 'Enter 10-character passcode',
                  filled: true,
                  fillColor: cs.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.large,
                    borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppRadius.large,
                    borderSide: BorderSide(color: cs.outline.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppRadius.large,
                    borderSide: BorderSide(color: cs.primary, width: 2),
                  ),
                  suffixIcon: IconButton(
                    onPressed: _isLoading
                        ? null
                        : () => setState(() => _obscurePasscode = !_obscurePasscode),
                    icon: Icon(
                      _obscurePasscode ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              Center(
                child: Text(
                  'Use your 10-character passcode',
                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.6)),
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOtp,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continue'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
