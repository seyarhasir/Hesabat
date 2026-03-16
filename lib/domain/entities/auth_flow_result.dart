enum AuthFailureType {
  invalidPasscode,
  accountNotFound,
  inactiveAccount,
  relinkFailed,
  missingShopContext,
  network,
  unknown,
}

class AuthFailure {
  final AuthFailureType type;
  final String message;

  const AuthFailure({
    required this.type,
    required this.message,
  });
}

class AuthFlowResult {
  final bool success;
  final String? shopId;
  final AuthFailure? failure;

  const AuthFlowResult._({
    required this.success,
    this.shopId,
    this.failure,
  });

  const AuthFlowResult.success({required String shopId})
      : this._(success: true, shopId: shopId);

  const AuthFlowResult.failure(AuthFailure failure)
      : this._(success: false, failure: failure);
}
