import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:hesabat/features/sales/screens/sale_screen.dart';
import 'package:hesabat/core/database/app_database.dart';
import 'package:hesabat/core/database/database_provider.dart';
import 'package:hesabat/shared/widgets/product_card.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  testWidgets('SaleScreen adds product to cart', (WidgetTester tester) async {
    // Seed some products
    await db.into(db.products).insert(
      ProductsCompanion.insert(
        id: const Value('p1'),
        shopId: 'demo_shop',
        nameDari: 'Tea',
        namePashto: const Value('Chai'),
        nameEn: const Value('Tea'),
        price: const Value(100.0),
        stockQuantity: const Value(10.0),
        unit: const Value('kg'),
        categoryId: const Value('Drinks'),
        isActive: const Value(true),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: SaleScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify initial state
    expect(find.text('New Sale'), findsWidgets); // Segment and title
    
    // Search for "Tea"
    await tester.enterText(find.byType(TextField), 'Tea');
    await tester.pump(); // Start search
    await tester.pump(const Duration(milliseconds: 500)); // Wait for search bounce if any
    await tester.pumpAndSettle();

    // Find and tap add button on ProductCard
    expect(find.byType(ProductCard), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add_circle_rounded));
    await tester.pumpAndSettle();

    // Clear search to see cart
    await tester.tap(find.byIcon(Icons.clear_rounded));
    await tester.pumpAndSettle();

    // Verify product added to cart
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Tea'), findsWidgets);
    
    // Verify total amount updated
    expect(find.text('Total Amount'), findsOneWidget);
    // Since it's 100 AFN
    expect(find.textContaining('100'), findsWidgets);
  });
}
