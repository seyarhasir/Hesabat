import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthSessionService {
  AuthSessionService(this._supabase);

  final SupabaseClient _supabase;

  Session? get currentSession => _supabase.auth.currentSession;

  Stream<Session?> sessionChanges() {
    return _supabase.auth.onAuthStateChange.map((event) => event.session);
  }

  Future<void> signOut() => _supabase.auth.signOut();

  Future<void> dispose() async {
    // no-op for now; stream is managed by Supabase SDK
  }
}
