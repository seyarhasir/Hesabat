import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'bootstrap/bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Force vertical-only orientation across the app.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final bootstrapResult = await bootstrapApp();

  runApp(
    ProviderScope(
      overrides: [
        bootstrapResultProvider.overrideWithValue(bootstrapResult),
      ],
      child: const HesabatApp(),
    ),
  );
}
