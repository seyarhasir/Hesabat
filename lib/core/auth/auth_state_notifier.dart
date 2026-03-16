import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/remote/supabase/supabase_client_provider.dart';
import '../../data/repositories/auth_repository_provider.dart';
import '../../domain/entities/auth_flow_result.dart';
import 'auth_orchestrator.dart';
import 'auth_session_service.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
  refreshing,
  error,
}

class AuthViewState {
  final AuthStatus status;
  final Session? session;
  final String? shopId;
  final String? errorMessage;
  final AuthFailureType? errorType;

  const AuthViewState({
    required this.status,
    this.session,
    this.shopId,
    this.errorMessage,
    this.errorType,
  });

  const AuthViewState.unknown() : this(status: AuthStatus.unknown);

  const AuthViewState.authenticated(Session session, {String? shopId})
      : this(
          status: AuthStatus.authenticated,
          session: session,
          shopId: shopId,
        );

  const AuthViewState.unauthenticated()
      : this(status: AuthStatus.unauthenticated);

  const AuthViewState.error() : this(status: AuthStatus.error);
}

class AuthStateNotifier extends Notifier<AuthViewState> {
  StreamSubscription<Session?>? _sub;

  @override
  AuthViewState build() {
    final supabase = ref.read(supabaseClientProvider);
    final service = AuthSessionService(supabase);

    ref.onDispose(() async {
      await _sub?.cancel();
      await service.dispose();
    });

    final current = service.currentSession;
    final initial = current == null
        ? const AuthViewState.unauthenticated()
        : AuthViewState.authenticated(current);

    _sub = service.sessionChanges().listen((session) {
      if (session == null) {
        if (state.status == AuthStatus.refreshing) {
          return;
        }
        if (state.status == AuthStatus.error) {
          return;
        }
        state = const AuthViewState.unauthenticated();
      } else {
        state = AuthViewState.authenticated(
          session,
          shopId: state.shopId,
        );
      }
    });

    return initial;
  }

  Future<void> signInWithPasscode({
    required String phone,
    required String passcode,
  }) async {
    state = const AuthViewState(status: AuthStatus.refreshing);

    try {
      final result = await ref.read(authOrchestratorProvider).signInWithPasscode(
        phone: phone,
        passcode: passcode,
      );

      if (!result.success) {
        state = AuthViewState(
          status: AuthStatus.error,
          errorType: result.failure?.type,
          errorMessage: result.failure?.message ?? 'Sign in failed',
        );
        return;
      }

      final session = ref.read(supabaseClientProvider).auth.currentSession;
      if (session == null) {
        state = const AuthViewState(
          status: AuthStatus.error,
          errorType: AuthFailureType.unknown,
          errorMessage:
              'Sign in could not complete. Session was not created. Check Supabase Auth settings and account password mapping.',
        );
        return;
      }

      state = AuthViewState.authenticated(
        session,
        shopId: result.shopId,
      );
    } on AuthException catch (e) {
      state = AuthViewState(
        status: AuthStatus.error,
        errorType: AuthFailureType.unknown,
        errorMessage: e.message,
      );
    } catch (e) {
      state = AuthViewState(
        status: AuthStatus.error,
        errorType: AuthFailureType.unknown,
        errorMessage: 'Unexpected sign in error: $e',
      );
    }
  }

  Future<void> signOutAtomic() async {
    state = const AuthViewState(status: AuthStatus.refreshing);

    try {
      await ref.read(authOrchestratorProvider).signOutAtomic();
      state = const AuthViewState.unauthenticated();
    } catch (_) {
      state = const AuthViewState.error();
    }
  }

  Future<bool> checkAdminAccountExists(String phone) async {
    try {
      final rpc = ref.read(authRpcClientProvider);
      return await rpc.adminAccountExists(phone);
    } catch (_) {
      return false;
    }
  }

  void clearError() {
    if (state.status == AuthStatus.error) {
      state = const AuthViewState.unauthenticated();
    }
  }
}

final authStateNotifierProvider =
    NotifierProvider<AuthStateNotifier, AuthViewState>(AuthStateNotifier.new);
