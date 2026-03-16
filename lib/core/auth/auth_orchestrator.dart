import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/auth_flow_result.dart';
import '../../domain/usecases/auth_usecase_providers.dart';

class AuthOrchestrator {
  final Ref _ref;

  const AuthOrchestrator(this._ref);

  Future<AuthFlowResult> signInWithPasscode({
    required String phone,
    required String passcode,
  }) {
    return _ref.read(signInWithPasscodeProvider).call(
          phone: phone,
          passcode: passcode,
        );
  }

  Future<void> signOutAtomic() {
    return _ref.read(signOutProvider).call();
  }
}

final authOrchestratorProvider = Provider<AuthOrchestrator>((ref) {
  return AuthOrchestrator(ref);
});
