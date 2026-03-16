import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/core/auth/auth_failure_ui.dart';
import 'package:hesabat/domain/entities/auth_flow_result.dart';

void main() {
  test('maps inactive account to support-hint UI', () {
    final model = mapAuthFailureToUi(
      type: AuthFailureType.inactiveAccount,
      fallbackMessage: null,
    );

    expect(model.title, 'Account inactive');
    expect(model.showSupportHint, isTrue);
  });

  test('maps unknown to fallback message', () {
    final model = mapAuthFailureToUi(
      type: null,
      fallbackMessage: 'raw error',
    );

    expect(model.title, 'Sign in failed');
    expect(model.description, 'raw error');
  });
}
