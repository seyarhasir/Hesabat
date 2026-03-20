import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hesabat/features/onboarding/screens/language_selection_screen.dart';
import 'package:hesabat/core/settings/app_locale_provider.dart';

void main() {
  testWidgets('LanguageSelectionScreen displays languages and handles selection', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: LanguageSelectionScreen(),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Select Language'), findsOneWidget);
    expect(find.text('Dari'), findsOneWidget);
    expect(find.text('Pashto'), findsOneWidget);
    expect(find.text('English'), findsNWidgets(2)); // name and nameEn are both "English"

    // Initial language is English (from provider default)
    expect(find.byIcon(Icons.check_circle_rounded), findsNWidgets(1));
    
    // Check for RTL hint - should not be visible for English
    expect(find.text('Layout will switch to right-to-left (RTL)'), findsNothing);

    // Tap on Dari (فارسی (دری))
    await tester.tap(find.textContaining('فارسی'));
    await tester.pump();

    // Verify checkmark moved and RTL hint appeared
    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.text('Layout will switch to right-to-left (RTL)'), findsOneWidget);

    // Verify "Continue" button is enabled
    final continueButton = find.text('Continue');
    expect(continueButton, findsOneWidget);
  });
}
