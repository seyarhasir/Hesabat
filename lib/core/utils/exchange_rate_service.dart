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
      final resp = await _dio.get('https://open.er-api.com/v6/latest/AFN');
      final data = resp.data;
      if (data is! Map) return null;

      final ratesRaw = data['rates'];
      if (ratesRaw is! Map) return null;

      final usd = (ratesRaw['USD'] as num?)?.toDouble();
      final pkr = (ratesRaw['PKR'] as num?)?.toDouble();
      if (usd == null || pkr == null || usd <= 0 || pkr <= 0) return null;

      final snapshot = ExchangeRateSnapshot(
        fetchedAt: DateTime.now(),
        ratesFromAfn: {
          'AFN': 1.0,
          'USD': usd,
          'PKR': pkr,
        },
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

    await db.batch((b) {
      b.insertAll(db.exchangeRates, [
        ExchangeRatesCompanion(
          fromCurrency: const Value('AFN'),
          toCurrency: const Value('USD'),
          rate: Value(snapshot.ratesFromAfn['USD'] ?? 0.013),
          fetchedAt: Value(snapshot.fetchedAt),
        ),
        ExchangeRatesCompanion(
          fromCurrency: const Value('AFN'),
          toCurrency: const Value('PKR'),
          rate: Value(snapshot.ratesFromAfn['PKR'] ?? 3.6),
          fetchedAt: Value(snapshot.fetchedAt),
        ),
      ]);
    });
  }

  Future<ExchangeRateSnapshot?> _readFromDb() async {
    final db = _db;
    if (db == null) return null;

    final usd = await (db.select(db.exchangeRates)
          ..where((t) => t.fromCurrency.equals('AFN') & t.toCurrency.equals('USD'))
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(1))
        .getSingleOrNull();

    final pkr = await (db.select(db.exchangeRates)
          ..where((t) => t.fromCurrency.equals('AFN') & t.toCurrency.equals('PKR'))
          ..orderBy([(t) => OrderingTerm.desc(t.fetchedAt)])
          ..limit(1))
        .getSingleOrNull();

    if (usd == null || pkr == null) return null;
    final fetchedAt = usd.fetchedAt.isAfter(pkr.fetchedAt) ? usd.fetchedAt : pkr.fetchedAt;

    return ExchangeRateSnapshot(
      fetchedAt: fetchedAt,
      ratesFromAfn: {
        'AFN': 1.0,
        'USD': usd.rate,
        'PKR': pkr.rate,
      },
    );
  }
}
