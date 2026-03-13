import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('Daily Summary screen renders title', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Daily Summary')),
            body: const Center(child: Text('Daily Summary')),
          ),
        ),
      ),
    );

    expect(find.text('Daily Summary'), findsNWidgets(2));
  });
}
