import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_provider.dart';
import '../../../shared/widgets/app_button.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  String _normalizeDigits(String input) {
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    const ar = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var out = input;
    for (var i = 0; i < 10; i++) {
      out = out.replaceAll(fa[i], '$i').replaceAll(ar[i], '$i');
    }
    return out;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() => _error = 'Please enter your phone number');
      return;
    }

    final cleanPhone = _normalizeDigits(phone).replaceAll(RegExp(r'[^0-9]'), '');

    String? national;
    if (cleanPhone.startsWith('93') && cleanPhone.length == 11) {
      national = cleanPhone.substring(2);
    } else if (cleanPhone.startsWith('07') && cleanPhone.length == 10) {
      national = cleanPhone.substring(1);
    } else if (cleanPhone.startsWith('7') && cleanPhone.length == 9) {
      national = cleanPhone;
    }

    if (national == null || !RegExp(r'^7\d{8}$').hasMatch(national)) {
      setState(() => _error = 'Invalid Afghan number format');
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    final fullPhone = '+93$national';
    final success = await ref.read(authProvider.notifier).signIn(fullPhone);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pushReplacementNamed(context, '/auth/otp', arguments: {'phone': fullPhone});
      } else {
        final err = ref.read(authProvider).error;
        setState(() => _error = err ?? 'Account not found. Contact sales agent.');
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
                        child: Icon(Icons.phone_iphone_rounded, size: 32, color: cs.primary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Welcome Back',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Enter your registered phone number to access your business dashboard.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),

                      // Refined Phone Input
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'Phone Number',
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
                                color: _error != null ? cs.error : cs.outline.withOpacity(0.2),
                                width: _error != null ? 2 : 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.primary.withOpacity(0.03),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(20, 18, 12, 18),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('\u{1F1E6}\u{1F1EB}', style: TextStyle(fontSize: 22)),
                                      const SizedBox(width: 10),
                                      Text(
                                        '+93',
                                        style: theme.textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: cs.onSurface,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        width: 1.5,
                                        height: 24,
                                        color: cs.outline.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    autofocus: true,
                                    maxLength: 12,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.5,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '7X XXX XXXX',
                                      hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.35)),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                      counterText: '',
                                    ),
                                    onChanged: (v) {
                                      final normalized = _normalizeDigits(v);
                                      if (normalized != v) {
                                        _phoneController.value = TextEditingValue(
                                          text: normalized,
                                          selection: TextSelection.collapsed(offset: normalized.length),
                                        );
                                      }
                                      if (_error != null) setState(() => _error = null);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: cs.errorContainer.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline_rounded, size: 16, color: cs.error),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _error!,
                                  style: theme.textTheme.bodySmall?.copyWith(color: cs.onErrorContainer),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),

                      // Helping info
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: cs.outline.withOpacity(0.1)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: cs.secondary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(Icons.vpn_key_outlined, color: cs.secondary, size: 20),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                'You will need your account passcode in the next step.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: cs.onSurface.withOpacity(0.7),
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
                    text: 'Continue',
                    onPressed: _isLoading ? null : _onContinue,
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
