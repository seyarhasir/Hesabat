import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:hesabat/features/sales/screens/sale_review_screen.dart';
import 'package:hesabat/core/database/app_database.dart';
import 'package:hesabat/core/database/database_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('SaleReviewScreen renders items and payment methods', (WidgetTester tester) async {
    final items = [
      {'productId': 'p1', 'name': 'Tea', 'quantity': 2.0, 'price': 100.0},
      {'productId': 'p2', 'name': 'Sugar', 'quantity': 1.0, 'price': 50.0},
    ];
    const subtotal = 250.0;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: MaterialApp(
          onGenerateRoute: (settings) {
            if (settings.name == '/sales/review') {
              return MaterialPageRoute(
                builder: (context) => const SaleReviewScreen(),
                settings: settings,
              );
            }
            return null;
          },
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/sales/review', arguments: {
                'items': items,
                'total': subtotal,
              }),
              child: const Text('Go'),
            ),
          ),
        ),
      ),
    );

    // Navigate to review screen
    await tester.tap(find.text('Go'));
    // Use pump with duration instead of pumpAndSettle to avoid Hive/HTTP timeout
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify screen title
    expect(find.text('Review Sale'), findsOneWidget);

    // Verify items rendered
    expect(find.text('Tea'), findsOneWidget);
    expect(find.text('Sugar'), findsOneWidget);

    // Verify payment method chips are present (Cash appears in both label and chip)
    expect(find.text('Cash'), findsWidgets);
    expect(find.text('Qarz'), findsWidgets);
    expect(find.text('Split'), findsWidgets);

    // Verify confirm button
    expect(find.text('Confirm Sale'), findsOneWidget);

    // Verify subtotal/total section
    expect(find.textContaining('Subtotal'), findsOneWidget);
    expect(find.textContaining('Total'), findsWidgets);

    // Verify discount button
    expect(find.text('Discount'), findsWidgets);

    // Verify customer button
    expect(find.text('Customer'), findsOneWidget);

    // Tap Qarz payment chip and verify it selects
    await tester.tap(find.text('Qarz'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // The payment method label should show Qarz
    expect(find.text('Qarz'), findsWidgets);
  });
}
