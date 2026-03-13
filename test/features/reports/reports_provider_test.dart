import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hesabat/features/reports/providers/reports_provider.dart';

void main() {
  group('ReportsNotifier', () {
    test('caches and retrieves report data', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reportsProvider.notifier);
      notifier.cacheReportData('sales_summary', {'revenue': 1200.0});

      final cached = notifier.getCachedReportData<Map<String, Object?>>('sales_summary');
      expect(cached?['revenue'], 1200.0);
    });

    test('stores date range per report', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reportsProvider.notifier);
      final range = DateTimeRange(
        start: DateTime(2026, 3, 1),
        end: DateTime(2026, 3, 31),
      );
      notifier.setDateRange('sales', range);

      expect(notifier.getDateRange('sales')?.start, range.start);
      expect(notifier.getDateRange('sales')?.end, range.end);
    });

    test('tracks report view analytics', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reportsProvider.notifier);
      notifier.trackReportView('sales');
      notifier.trackReportView('sales');

      final state = container.read(reportsProvider);
      expect(state.viewCounts['sales'], 2);
      expect(state.lastViewedAt['sales'], isNotNull);
    });

    test('runReportGeneration toggles in-progress flag', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(reportsProvider.notifier);

      final future = notifier.runReportGeneration<String>('sales_pdf', () async {
        expect(notifier.isGeneratingFor('sales_pdf'), isTrue);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        return 'done';
      });

      final result = await future;
      expect(result, 'done');
      expect(notifier.isGeneratingFor('sales_pdf'), isFalse);
    });
  });
}
