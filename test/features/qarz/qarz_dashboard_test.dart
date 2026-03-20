import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:hesabat/features/qarz/screens/qarz_dashboard_screen.dart';
import 'package:hesabat/core/database/app_database.dart';
import 'package:hesabat/core/database/database_provider.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
  });

  // Close DB and clear widget tree before tearDown to prevent pending timer error
  Future<void> cleanUp(WidgetTester tester) async {
    await db.close();
    await tester.pumpWidget(const SizedBox.shrink());
  }

  testWidgets('QarzDashboard shows empty state when no debts', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: QarzDashboardScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify title
    expect(find.text('Qarz'), findsOneWidget);

    // Verify empty state message
    expect(find.text('No debts found'), findsOneWidget);
    expect(find.text('Add a new qarz to get started'), findsOneWidget);

    // Verify FAB add button
    expect(find.byIcon(Icons.add_rounded), findsOneWidget);

    await cleanUp(tester);
  });

  testWidgets('QarzDashboard shows debt cards after seeding data', (WidgetTester tester) async {
    // Seed customer
    await db.into(db.customers).insert(
      CustomersCompanion.insert(
        id: const Value('c1'),
        shopId: 'demo_shop',
        name: 'Ahmad',
        phone: const Value('+93700000000'),
        totalOwed: const Value(500.0),
      ),
    );

    // Seed debt
    await db.into(db.debts).insert(
      DebtsCompanion.insert(
        id: const Value('d1'),
        shopId: 'demo_shop',
        customerId: 'c1',
        amountOriginal: 500.0,
        amountRemaining: const Value(500.0),
        status: const Value('open'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: QarzDashboardScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Verify title
    expect(find.text('Qarz'), findsOneWidget);

    // Verify hero total owed section
    expect(find.text('Total owed to you'), findsOneWidget);

    // Verify customer name in debt card
    expect(find.text('Ahmad'), findsOneWidget);

    // Verify Amount Owed label
    expect(find.text('Amount Owed'), findsOneWidget);

    // Verify action buttons are present
    expect(find.text('Reminder'), findsOneWidget);
    expect(find.text('Pay'), findsOneWidget);

    // Verify stat chips
    expect(find.textContaining('1 customers'), findsOneWidget);

    await cleanUp(tester);
  });

  testWidgets('QarzDashboard search filters debts', (WidgetTester tester) async {
    // Seed two customers
    await db.into(db.customers).insert(
      CustomersCompanion.insert(
        id: const Value('c1'),
        shopId: 'demo_shop',
        name: 'Ahmad',
        phone: const Value('+93700000001'),
        totalOwed: const Value(500.0),
      ),
    );
    await db.into(db.customers).insert(
      CustomersCompanion.insert(
        id: const Value('c2'),
        shopId: 'demo_shop',
        name: 'Bashir',
        phone: const Value('+93700000002'),
        totalOwed: const Value(300.0),
      ),
    );

    // Seed debts
    await db.into(db.debts).insert(
      DebtsCompanion.insert(
        id: const Value('d1'),
        shopId: 'demo_shop',
        customerId: 'c1',
        amountOriginal: 500.0,
        amountRemaining: const Value(500.0),
        status: const Value('open'),
      ),
    );
    await db.into(db.debts).insert(
      DebtsCompanion.insert(
        id: const Value('d2'),
        shopId: 'demo_shop',
        customerId: 'c2',
        amountOriginal: 300.0,
        amountRemaining: const Value(300.0),
        status: const Value('open'),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
        ],
        child: const MaterialApp(
          home: QarzDashboardScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Both customers should be visible
    expect(find.text('Ahmad'), findsOneWidget);
    expect(find.text('Bashir'), findsOneWidget);

    // Search for Bashir
    await tester.enterText(find.byType(TextField), 'Bashir');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Only Bashir should be visible (appears in card + search field)
    expect(find.text('Bashir'), findsWidgets);
    expect(find.text('Ahmad'), findsNothing);

    await cleanUp(tester);
  });
}
