import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_provider.dart';
import 'sign_in_with_passcode.dart';
import 'sign_out.dart';

final signInWithPasscodeProvider = Provider<SignInWithPasscode>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignInWithPasscode(repo);
});

final signOutProvider = Provider<SignOut>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return SignOut(repo);
});
