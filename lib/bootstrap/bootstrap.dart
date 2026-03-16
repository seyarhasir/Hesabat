import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/env.dart';
import '../core/errors/app_failures.dart';
import '../core/logging/app_logger.dart';
import '../data/remote/supabase/supabase_initializer.dart';

class BootstrapResult {
  final bool success;
  final AppFailure? failure;
  final EnvConfig? env;

  const BootstrapResult._({
    required this.success,
    this.failure,
    this.env,
  });

  const BootstrapResult.success(EnvConfig env)
      : this._(success: true, env: env);

  const BootstrapResult.failure(AppFailure failure)
      : this._(success: false, failure: failure);
}

final bootstrapResultProvider = Provider<BootstrapResult>((ref) {
  throw UnimplementedError('bootstrapResultProvider must be overridden in main()');
});

Future<BootstrapResult> bootstrapApp() async {
  AppLogger.info('Bootstrap started');

  try {
    final env = await EnvConfig.load();
    await SupabaseInitializer.initialize(env);

    AppLogger.info('Bootstrap completed');
    return BootstrapResult.success(env);
  } catch (e, st) {
    final failure = BootstrapFailure(
      message: 'App bootstrap failed',
      details: e.toString(),
      stackTrace: st,
    );

    AppLogger.error(failure.message, error: e, stackTrace: st);
    return BootstrapResult.failure(failure);
  }
}
