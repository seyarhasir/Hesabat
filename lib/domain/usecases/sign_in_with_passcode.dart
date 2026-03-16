import '../entities/auth_flow_result.dart';
import '../repositories/auth_repository.dart';

class SignInWithPasscode {
  final AuthRepository _repository;

  const SignInWithPasscode(this._repository);

  Future<AuthFlowResult> call({
    required String phone,
    required String passcode,
  }) {
    return _repository.signInWithPasscode(
      phone: phone,
      passcode: passcode,
    );
  }
}
