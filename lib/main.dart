import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'shared/theme/app_theme.dart';
import 'shared/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );
  
  runApp(
    const ProviderScope(
      child: HesabatApp(),
    ),
  );
}

class HesabatApp extends StatelessWidget {
  const HesabatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hesabat',
      debugShowCheckedModeBanner: false,
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      
      // Localization
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fa'), // Dari - RTL
        Locale('ps'), // Pashto - RTL
        Locale('en'), // English - LTR
      ],
      locale: const Locale('fa'), // Default to Dari
      
      // RTL support
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      
      home: const Scaffold(
        body: Center(
          child: Text(
            'Hesabat - حسابات',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
