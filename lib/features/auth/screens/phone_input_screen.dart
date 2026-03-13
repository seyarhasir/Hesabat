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

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');

    if (!RegExp(r'^07\d{8}$').hasMatch(cleanPhone)) {
      setState(() => _error = 'Enter a valid Afghan number (07X XXX XXXX)');
      return;
    }

    setState(() { _isLoading = true; _error = null; });

    final fullPhone = '+93${cleanPhone.substring(1)}';
    final success = await ref.read(authProvider.notifier).signIn(fullPhone);

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        Navigator.pushNamed(context, '/auth/otp', arguments: {'phone': fullPhone});
      } else {
        setState(() => _error = 'Account not found. Contact sales agent.');
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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Text('Enter Your Phone', style: theme.textTheme.displaySmall),
              const SizedBox(height: 8),
              Text(
                'We\'ll send a code via WhatsApp',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),

              // Phone input
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _error != null ? cs.error : cs.outline,
                    width: _error != null ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: cs.surfaceContainerHighest.withOpacity(0.3),
                        borderRadius: const BorderRadius.horizontal(left: Radius.circular(19)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('\u{1F1E6}\u{1F1EB}', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 8),
                          Text('+93', style: theme.textTheme.bodyLarge),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                        decoration: const InputDecoration(
                          hintText: '07X XXX XXXX',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          counterText: '',
                          filled: false,
                        ),
                        onChanged: (_) => setState(() => _error = null),
                      ),
                    ),
                  ],
                ),
              ),

              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: TextStyle(color: cs.error, fontSize: 14)),
              ],

              const SizedBox(height: 16),

              // Info
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cs.secondary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: cs.outline),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: cs.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Your number must be registered by our sales team.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: 'Continue',
                  onPressed: _isLoading ? null : _onContinue,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
