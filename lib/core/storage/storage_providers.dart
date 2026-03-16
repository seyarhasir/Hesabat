import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local_kv_store.dart';
import 'secure_store.dart';

final secureStoreProvider = Provider<SecureStore>((ref) {
  return SecureStore();
});

final localKvStoreProvider = Provider<LocalKvStore>((ref) {
  return LocalKvStore();
});
