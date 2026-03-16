import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/storage_providers.dart';
import '../../domain/repositories/auth_repository.dart';
import '../remote/supabase/rpc/auth_rpc_client.dart';
import '../remote/supabase/supabase_client_provider.dart';
import 'auth_repository_impl.dart';

final authRpcClientProvider = Provider<AuthRpcClient>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  return AuthRpcClient(supabase);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final supabase = ref.read(supabaseClientProvider);
  final rpc = ref.read(authRpcClientProvider);
  final secureStore = ref.read(secureStoreProvider);
  final localKvStore = ref.read(localKvStoreProvider);

  return AuthRepositoryImpl(
    supabase: supabase,
    rpc: rpc,
    secureStore: secureStore,
    localKvStore: localKvStore,
  );
});
