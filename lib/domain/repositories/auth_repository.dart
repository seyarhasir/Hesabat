import '../entities/auth_flow_result.dart';

abstract class AuthRepository {
  Future<AuthFlowResult> signInWithPasscode({
    required String phone,
    required String passcode,
  });

  Future<void> atomicSignOut();
}
