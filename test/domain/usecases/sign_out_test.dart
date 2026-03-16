import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/domain/entities/auth_flow_result.dart';
import 'package:hesabat/domain/repositories/auth_repository.dart';
import 'package:hesabat/domain/usecases/sign_out.dart';

class _FakeAuthRepository implements AuthRepository {
  bool signOutCalled = false;

  @override
  Future<void> atomicSignOut() async {
    signOutCalled = true;
  }

  @override
  Future<AuthFlowResult> signInWithPasscode({
    required String phone,
    required String passcode,
  }) {
    return Future.value(
      const AuthFlowResult.failure(
        AuthFailure(
          type: AuthFailureType.unknown,
          message: 'not used in this test',
        ),
      ),
    );
  }
}

void main() {
  test('calls repository atomic sign out', () async {
    final fakeRepo = _FakeAuthRepository();
    final usecase = SignOut(fakeRepo);

    await usecase();

    expect(fakeRepo.signOutCalled, isTrue);
  });
}
