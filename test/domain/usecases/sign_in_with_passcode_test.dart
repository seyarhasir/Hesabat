import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/domain/entities/auth_flow_result.dart';
import 'package:hesabat/domain/repositories/auth_repository.dart';
import 'package:hesabat/domain/usecases/sign_in_with_passcode.dart';

class _FakeAuthRepository implements AuthRepository {
  bool signOutCalled = false;

  @override
  Future<AuthFlowResult> signInWithPasscode({
    required String phone,
    required String passcode,
  }) async {
    if (phone == '+93770000000' && passcode == 'PASSCODE10X') {
      return const AuthFlowResult.success(shopId: 'shop_1');
    }
    return const AuthFlowResult.failure(
      AuthFailure(
        type: AuthFailureType.invalidPasscode,
        message: 'invalid',
      ),
    );
  }

  @override
  Future<void> atomicSignOut() async {
    signOutCalled = true;
  }
}

void main() {
  test('returns success for valid credentials', () async {
    final usecase = SignInWithPasscode(_FakeAuthRepository());

    final result = await usecase(
      phone: '+93770000000',
      passcode: 'PASSCODE10X',
    );

    expect(result.success, isTrue);
    expect(result.shopId, 'shop_1');
  });

  test('returns failure for invalid credentials', () async {
    final usecase = SignInWithPasscode(_FakeAuthRepository());

    final result = await usecase(
      phone: '+93770000000',
      passcode: 'BAD',
    );

    expect(result.success, isFalse);
    expect(result.failure?.type, AuthFailureType.invalidPasscode);
  });
}
