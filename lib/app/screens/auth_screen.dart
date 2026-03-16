import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/auth/auth_failure_ui.dart';
import '../../core/auth/auth_state_notifier.dart';
import '../../domain/entities/auth_flow_result.dart';
import '../../shared/widgets/app_button.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

enum _AuthStep {
  phone,
  passcode,
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late final TextEditingController _phoneController;
  late final TextEditingController _passcodeController;
  _AuthStep _step = _AuthStep.phone;
  bool _checkingPhone = false;
  String? _localError;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _passcodeController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  String _normalizePhone(String input) {
    var out = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (out.startsWith('93') && out.length > 2) {
      out = out.substring(2);
    } else if (out.startsWith('0') && out.length > 1) {
      out = out.substring(1);
    }
    return out;
  }

  Future<void> _launchWhatsApp() async {
    final url = Uri.parse('https://wa.me/93772654965');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final auth = ref.watch(authStateNotifierProvider);
    final isLoading = auth.status == AuthStatus.refreshing || _checkingPhone;
    final canSubmitPasscode = _isStrongPasscode(_passcodeController.text.trim());

    return Scaffold(
      backgroundColor: cs.surface,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primary.withOpacity(0.12),
              cs.surface,
              cs.secondary.withOpacity(0.04),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 16),
              if (_step == _AuthStep.passcode)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded),
                        onPressed: isLoading
                            ? null
                            : () {
                                setState(() {
                                  _step = _AuthStep.phone;
                                  _passcodeController.clear();
                                  _localError = null;
                                });
                              },
                      ),
                    ],
                  ),
                )
              else
                const SizedBox(height: 48),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Premium Icon (Only for Passcode)
                      if (_step == _AuthStep.passcode)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.lock_person_rounded,
                            size: 32,
                            color: cs.primary,
                          ),
                        ),
                      if (_step == _AuthStep.passcode) const SizedBox(height: 24),
                      Text(
                        _step == _AuthStep.phone ? 'Welcome Back' : 'Security Check',
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _step == _AuthStep.phone
                            ? 'Enter your registered phone number to access your business dashboard.'
                            : 'Enter the 10-character passcode assigned to your admin account.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: cs.onSurface.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 48),

                      if (_step == _AuthStep.phone) ...[
                        _buildLabel(context, 'Phone Number'),
                        _buildInputContainer(
                          context,
                          Row(
                            children: [
                              Padding(
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
                                    Container(width: 1.5, height: 24, color: cs.outline.withOpacity(0.15)),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: TextField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  autofocus: false,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.5,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: '7X XXX XXXX',
                                    hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.3)),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else ...[
                        _buildLabel(context, 'Account: ${ref.read(authStateNotifierProvider.notifier).formatPhoneForDisplay(_phoneController.text.trim())}'),
                        _buildInputContainer(
                          context,
                          TextField(
                            controller: _passcodeController,
                            autofocus: false,
                            obscureText: true,
                            style: theme.textTheme.titleMedium?.copyWith(
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                            decoration: InputDecoration(
                              hintText: '••••••••••',
                              hintStyle: TextStyle(color: cs.onSurface.withOpacity(0.2), letterSpacing: 4),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.fromLTRB(24, 18, 24, 18),
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],

                      if (_localError != null || auth.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        _buildErrorBanner(context, _localError ?? auth.errorMessage!, auth.errorType),
                      ],

                      const SizedBox(height: 32),
                      
                      // Contact Admin / WhatsApp Tip
                      InkWell(
                        onTap: _launchWhatsApp,
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: cs.primary.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.chat_rounded, color: Colors.green, size: 20),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact Admin to create account',
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: cs.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Direct Support: +93 77 265 4965',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: cs.onSurface.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios_rounded, size: 14, color: cs.primary.withOpacity(0.5)),
                            ],
                          ),
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
                    text: _step == _AuthStep.phone ? 'Continue' : 'Sign In',
                    isLoading: isLoading,
                    onPressed: isLoading ? null : () => _handleAction(auth),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInputContainer(BuildContext context, Widget child) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cs.outline.withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cs.primary.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildErrorBanner(BuildContext context, String message, AuthFailureType? type) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.errorContainer.withOpacity(0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 20, color: cs.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onErrorContainer, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleAction(AuthViewState auth) async {
    if (_step == _AuthStep.phone) {
      final raw = _phoneController.text.trim();
      if (raw.isEmpty) {
        setState(() => _localError = 'Please enter your phone number.');
        return;
      }

      final national = _normalizePhone(raw);
      if (national.length < 9) {
        setState(() => _localError = 'Invalid phone number format.');
        return;
      }

      final fullPhone = '+93$national';

      setState(() {
        _localError = null;
        _checkingPhone = true;
      });

      final exists = await ref
          .read(authStateNotifierProvider.notifier)
          .checkAdminAccountExists(fullPhone);

      if (!mounted) return;

      setState(() {
        _checkingPhone = false;
        if (exists) {
          _step = _AuthStep.passcode;
        } else {
          _localError = 'No account found for $fullPhone. Please contact support.';
        }
      });
      return;
    }

    final passcode = _passcodeController.text.trim();
    if (!_isStrongPasscode(passcode)) {
      setState(() => _localError = 'Invalid passcode format.');
      return;
    }

    setState(() => _localError = null);
    ref.read(authStateNotifierProvider.notifier).clearError();

    final national = _normalizePhone(_phoneController.text.trim());
    await ref.read(authStateNotifierProvider.notifier).signInWithPasscode(
          phone: '+93$national',
          passcode: passcode,
        );
  }

  bool _isStrongPasscode(String value) {
    // Keep it simple for compatibility but ensure it's not empty
    return value.length >= 6;
  }
}
