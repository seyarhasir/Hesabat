import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../shared/theme/app_colors.dart';
import '../../../shared/theme/app_layout.dart';
import '../../../shared/widgets/app_numeric_keypad.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpVerificationScreen({super.key, required this.phone});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<String> _otpDigits = List.filled(6, '');
  int _currentIndex = 0;
  bool _isLoading = false;
  int _resendCountdown = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() { _canResend = false; _resendCountdown = 60; });
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startResendTimer();
      } else if (mounted) {
        setState(() => _canResend = true);
      }
    });
  }

  void _onDigitPressed(String digit) {
    if (_currentIndex < 6) {
      setState(() {
        _otpDigits[_currentIndex] = digit;
        _currentIndex++;
      });
      if (_currentIndex == 6) _verifyOtp();
    }
  }

  void _onBackspace() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _otpDigits[_currentIndex] = '';
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).verifyOtp(
      widget.phone,
      _otpDigits.join(),
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pushReplacementNamed(context, '/onboarding/shop-setup');
      } else {
        setState(() {
          _otpDigits.fillRange(0, 6, '');
          _currentIndex = 0;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid code. Try again.')),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;
    setState(() => _isLoading = true);
    final success = await ref.read(authProvider.notifier).signIn(widget.phone);
    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('New code sent via WhatsApp'),
            backgroundColor: AppColors.success,
          ),
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
              Text('Verification Code', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Sent to ${widget.phone} via WhatsApp',
                style: theme.textTheme.bodyMedium?.copyWith(color: cs.onSurface.withOpacity(0.6)),
              ),
              const SizedBox(height: AppSpacing.sectionGap),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (i) {
                  final isFocused = i == _currentIndex;
                  final hasValue = _otpDigits[i].isNotEmpty;
                  return Container(
                    width: 44,
                    height: 56,
                    decoration: BoxDecoration(
                      color: hasValue ? cs.primary.withOpacity(0.05) : cs.surface,
                      borderRadius: AppRadius.medium,
                      border: Border.all(
                        color: isFocused ? cs.primary : cs.outline.withOpacity(0.3),
                        width: isFocused ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _otpDigits[i],
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: AppSpacing.sectionGap),

              // Resend
              Center(
                child: _canResend
                    ? TextButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        onPressed: _isLoading ? null : _resendOtp,
                        label: const Text('Resend via WhatsApp'),
                      )
                    : Text(
                        'Resend in ${_resendCountdown}s',
                        style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withOpacity(0.5)),
                      ),
              ),

              const Spacer(),

              // Use the shared keypad
              AppNumericKeypad(
                onDigitPressed: _onDigitPressed,
                onBackspace: _onBackspace,
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
