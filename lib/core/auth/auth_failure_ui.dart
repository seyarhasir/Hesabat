import '../../domain/entities/auth_flow_result.dart';

class AuthFailureUiModel {
  final String title;
  final String description;
  final bool showSupportHint;

  const AuthFailureUiModel({
    required this.title,
    required this.description,
    this.showSupportHint = false,
  });
}

AuthFailureUiModel mapAuthFailureToUi({
  required AuthFailureType? type,
  required String? fallbackMessage,
}) {
  switch (type) {
    case AuthFailureType.invalidPasscode:
      return const AuthFailureUiModel(
        title: 'Invalid passcode',
        description: 'Please check your passcode and try again.',
      );
    case AuthFailureType.accountNotFound:
      return const AuthFailureUiModel(
        title: 'Account not found',
        description: 'No active admin account exists for this phone number.',
        showSupportHint: true,
      );
    case AuthFailureType.inactiveAccount:
      return const AuthFailureUiModel(
        title: 'Account inactive',
        description: 'Your account is inactive. Please contact support.',
        showSupportHint: true,
      );
    case AuthFailureType.relinkFailed:
      return const AuthFailureUiModel(
        title: 'Account linking failed',
        description: 'We could not link your account to a shop. Please retry.',
        showSupportHint: true,
      );
    case AuthFailureType.missingShopContext:
      return const AuthFailureUiModel(
        title: 'Shop context missing',
        description: 'Signed in, but no shop is linked. Contact support if this continues.',
        showSupportHint: true,
      );
    case AuthFailureType.network:
      return const AuthFailureUiModel(
        title: 'Network issue',
        description: 'Please check your connection and try again.',
      );
    case AuthFailureType.unknown:
    case null:
      return AuthFailureUiModel(
        title: 'Sign in failed',
        description: fallbackMessage ?? 'Please try again.',
      );
  }
}
