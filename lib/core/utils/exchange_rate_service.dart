import 'dart:async';

import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../database/app_database.dart';

class ExchangeRateSnapshot {
  final DateTime fetchedAt;
  final Map<String, double> ratesFromAfn;

  const ExchangeRateSnapshot({
    required this.fetchedAt,
    required this.ratesFromAfn,
  });
}

class ExchangeRateService {
  ExchangeRateService._();
  static final ExchangeRateService instance = ExchangeRateService._();

  static const _cacheBox = 'exchange_rates_cache';
  static const _cacheKey = 'latest_snapshot';

  final Dio _dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 8), receiveTimeout: const Duration(seconds: 8)));

  AppDatabase? _db;
  Box<dynamic>? _box;

  Future<void> initialize(AppDatabase db) async {
    _db = db;
    await Hive.initFlutter();
    _box = await Hive.openBox<dynamic>(_cacheBox);
  }

  Future<ExchangeRateSnapshot> getLatestSnapshot({bool preferFresh = true}) async {
    final cached = _readCache();
    if (cached != null) {
      final age = DateTime.now().difference(cached.fetchedAt);
      if (!preferFresh || age <= const Duration(days: 1)) {
        return cached;
      }
    }

    final fetched = await _fetchAndPersist();
    if (fetched != null) return fetched;

    final fromDb = await _readFromDb();
    if (fromDb != null) return fromDb;

    final fallback = ExchangeRateSnapshot(
      fetchedAt: DateTime.now(),
      ratesFromAfn: const {
        'AFN': 1.0,
        'USD': 0.013,
        'PKR': 3.6,
      },
    );
    _writeCache(fallback);
    return fallback;
  }

  Future<double> getRate(String fromCurrency, String toCurrency) async {
    final from = fromCurrency.toUpperCase();
    final to = toCurrency.toUpperCase();
    if (from == to) return 1.0;

    final snapshot = await getLatestSnapshot(preferFresh: false);
    final fromAfn = snapshot.ratesFromAfn[from];
    final toAfn = snapshot.ratesFromAfn[to];
    if (fromAfn != null && toAfn != null && fromAfn > 0) {
      return toAfn / fromAfn;
    }

    return 1.0;
  }

  Future<DateTime?> getLastUpdatedAt() async {
    final cached = _readCache();
    if (cached != null) return cached.fetchedAt;
    final fromDb = await _readFromDb();
    return fromDb?.fetchedAt;
  }

  ExchangeRateSnapshot? _readCache() {
    final raw = _box?.get(_cacheKey);
    if (raw is! Map) return null;

    final fetchedAtRaw = raw['fetchedAt'];
    final ratesRaw = raw['rates'];
    if (fetchedAtRaw is! String || ratesRaw is! Map) return null;

    final fetchedAt = DateTime.tryParse(fetchedAtRaw);
    if (fetchedAt == null) return null;

    final rates = <String, double>{};
    for (final entry in ratesRaw.entries) {
      final key = entry.key.toString().toUpperCase();
      final value = (entry.value as num?)?.toDouble();
      if (value != null) rates[key] = value;
    }

    if (!rates.containsKey('AFN')) rates['AFN'] = 1.0;
    return ExchangeRateSnapshot(fetchedAt: fetchedAt, ratesFromAfn: rates);
  }

  void _writeCache(ExchangeRateSnapshot snapshot) {
    _box?.put(_cacheKey, {
      'fetchedAt': snapshot.fetchedAt.toIso8601String(),
      'rates': snapshot.ratesFromAfn,
    });
  }

  Future<ExchangeRateSnapshot?> _fetchAndPersist() async {
    try {
      final resp = await _dio.get('https://open.er-api.com/v6/latest/USD');
      final data = resp.data;
      if (data is! Map) return null;

      final ratesRaw = data['rates'];
      if (ratesRaw is! Map) return null;

      // Extract USD-based rates
      final afnInUsd = (ratesRaw['AFN'] as num?)?.toDouble();
      if (afnInUsd == null || afnInUsd <= 0) return null;

      // Calculate AFN-based rates for all returned currencies
      final ratesFromAfn = <String, double>{'AFN': 1.0};
      for (final entry in ratesRaw.entries) {
        final currency = entry.key.toString().toUpperCase();
        final valueInUsd = (entry.value as num?)?.toDouble();
        if (valueInUsd != null && valueInUsd > 0) {
          // If 1 USD = 72 AFN and 1 USD = 281 PKR, then 1 AFN = 281 / 72 PKR
          ratesFromAfn[currency] = valueInUsd / afnInUsd;
        }
      }

      final snapshot = ExchangeRateSnapshot(
        fetchedAt: DateTime.now(),
        ratesFromAfn: ratesFromAfn,
      );

      await _persistToDb(snapshot);
      _writeCache(snapshot);
      return snapshot;
    } catch (_) {
      return null;
    }
  }

  Future<void> _persistToDb(ExchangeRateSnapshot snapshot) async {
    final db = _db;
    if (db == null) return;

    // We only persist common currencies to avoid bloating the DB
    const common = {'AFN', 'USD', 'PKR', 'IRR', 'EUR', 'GBP', 'SAR', 'AED', 'TRY', 'CNY'};
    
    final companions = <ExchangeRatesCompanion>[];
    for (final entry in snapshot.ratesFromAfn.entries) {
      if (common.contains(entry.key) && entry.key != 'AFN') {
        companions.add(ExchangeRatesCompanion(
          fromCurrency: const Value('AFN'),
          toCurrency: Value(entry.key),
          rate: Value(entry.value),
          fetchedAt: Value(snapshot.fetchedAt),
        ));
      }
    }

    if (companions.isNotEmpty) {
      await db.batch((b) {
        b.insertAll(db.exchangeRates, companions);
      });
    }
  }

  Future<ExchangeRateSnapshot?> _readFromDb() async {
    final db = _db;
    if (db == null) return null;

    final latestRates = await (db.select(db.exchangeRates)
          ..where((t) => t.fromCurrency.equals('AFN'))
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)]))
        .get();

    if (latestRates.isEmpty) return null;

    final fetchedAt = latestRates.first.fetchedAt;
    final rates = <String, double>{'AFN': 1.0};
    
    // Group by timestamp (within 1 minute) to reconstruct snapshot
    for (final r in latestRates) {
      if (r.fetchedAt.difference(fetchedAt).abs().inMinutes < 1) {
        rates[r.toCurrency.toUpperCase()] = r.rate;
      }
    }

    return ExchangeRateSnapshot(fetchedAt: fetchedAt, ratesFromAfn: rates);
  }
}
