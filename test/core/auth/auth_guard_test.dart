import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/core/auth/auth_guard.dart';
import 'package:hesabat/core/auth/auth_state_notifier.dart';

void main() {
  test('loading states are unknown or refreshing', () {
    const unknown = AuthViewState.unknown();
    const refreshing = AuthViewState(status: AuthStatus.refreshing);

    expect(AuthGuard.isLoading(unknown), isTrue);
    expect(AuthGuard.isLoading(refreshing), isTrue);
  });

  test('error state is treated as unauthenticated', () {
    const error = AuthViewState.error();

    expect(AuthGuard.isUnauthenticated(error), isTrue);
  });
}
