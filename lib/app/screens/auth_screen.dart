import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_failure_ui.dart';
import '../../core/auth/auth_state_notifier.dart';
import '../../domain/entities/auth_flow_result.dart';

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

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateNotifierProvider);
    final isLoading = auth.status == AuthStatus.refreshing || _checkingPhone;
    final canSubmitPasscode = _isStrongPasscode(_passcodeController.text.trim());

    return Scaffold(
      appBar: AppBar(
        title: Text(_step == _AuthStep.phone ? 'Sign In' : 'Enter Passcode'),
        leading: _step == _AuthStep.passcode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: isLoading
                    ? null
                    : () {
                        setState(() {
                          _step = _AuthStep.phone;
                          _passcodeController.clear();
                          _localError = null;
                        });
                      },
              )
            : null,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
            Icon(
              Icons.lock_outline,
              size: 40,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              _step == _AuthStep.phone ? 'Step 1: Verify phone' : 'Step 2: Enter passcode',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            if (_step == _AuthStep.phone)
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  hintText: '+937xxxxxxxx',
                ),
              ),
            if (_step == _AuthStep.passcode)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Phone: ${_phoneController.text.trim()}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            const SizedBox(height: 12),
            if (_step == _AuthStep.passcode)
              TextField(
                controller: _passcodeController,
                decoration: const InputDecoration(
                  labelText: 'Passcode',
                  hintText: 'At least 8 chars (letters + numbers)',
                ),
                obscureText: true,
                onChanged: (_) => setState(() {}),
              ),
            const SizedBox(height: 16),
            if (_localError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _InlineErrorBanner(message: _localError!),
              ),
            if (auth.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AuthErrorBanner(
                  errorType: auth.errorType,
                  fallbackMessage: auth.errorMessage,
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_step == _AuthStep.phone) {
                          final phone = _phoneController.text.trim();
                          if (phone.isEmpty) {
                            setState(() => _localError = 'Enter phone number.');
                            return;
                          }

                          setState(() {
                            _localError = null;
                            _checkingPhone = true;
                          });

                          final exists = await ref
                              .read(authStateNotifierProvider.notifier)
                              .checkAdminAccountExists(phone);

                          if (!mounted) return;

                          setState(() {
                            _checkingPhone = false;
                            if (exists) {
                              _step = _AuthStep.passcode;
                            } else {
                              _localError =
                                  'No active account found for this phone. Contact admin.';
                            }
                          });
                          return;
                        }

                        final passcode = _passcodeController.text.trim();
                        if (!_isStrongPasscode(passcode)) {
                          setState(
                            () => _localError =
                                'Passcode must be at least 8 characters and include letters and numbers.',
                          );
                          return;
                        }

                        setState(() => _localError = null);
                        ref.read(authStateNotifierProvider.notifier).clearError();

                        await ref.read(authStateNotifierProvider.notifier).signInWithPasscode(
                              phone: _phoneController.text.trim(),
                              passcode: passcode,
                            );
                      },
                child: Text(
                  _buttonText(
                    isLoading: isLoading,
                    step: _step,
                    canSubmitPasscode: canSubmitPasscode,
                  ),
                ),
              ),
            ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isStrongPasscode(String value) {
    final regex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
    return regex.hasMatch(value);
  }

  String _buttonText({
    required bool isLoading,
    required _AuthStep step,
    required bool canSubmitPasscode,
  }) {
    if (isLoading) {
      return step == _AuthStep.phone ? 'Checking...' : 'Signing in...';
    }
    if (step == _AuthStep.phone) return 'Continue';
    return canSubmitPasscode ? 'Sign In' : 'Enter valid passcode';
  }
}

class _InlineErrorBanner extends StatelessWidget {
  final String message;

  const _InlineErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(color: cs.onErrorContainer),
      ),
    );
  }
}

class _AuthErrorBanner extends StatelessWidget {
  final AuthFailureType? errorType;
  final String? fallbackMessage;

  const _AuthErrorBanner({
    required this.errorType,
    required this.fallbackMessage,
  });

  @override
  Widget build(BuildContext context) {
    final mapped = mapAuthFailureToUi(
      type: errorType,
      fallbackMessage: fallbackMessage,
    );

    final cs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cs.errorContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mapped.title,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: cs.onErrorContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            mapped.description,
            style: TextStyle(color: cs.onErrorContainer),
          ),
          if (mapped.showSupportHint) ...[
            const SizedBox(height: 6),
            Text(
              'If this persists, contact support with your phone number.',
              style: TextStyle(
                color: cs.onErrorContainer,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
