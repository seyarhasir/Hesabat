import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ReportsState {
  final Map<String, Object?> cachedData;
  final Map<String, DateTimeRange> dateRanges;
  final Map<String, bool> isGenerating;
  final Map<String, int> viewCounts;
  final Map<String, DateTime> lastViewedAt;

  const ReportsState({
    this.cachedData = const {},
    this.dateRanges = const {},
    this.isGenerating = const {},
    this.viewCounts = const {},
    this.lastViewedAt = const {},
  });

  ReportsState copyWith({
    Map<String, Object?>? cachedData,
    Map<String, DateTimeRange>? dateRanges,
    Map<String, bool>? isGenerating,
    Map<String, int>? viewCounts,
    Map<String, DateTime>? lastViewedAt,
  }) {
    return ReportsState(
      cachedData: cachedData ?? this.cachedData,
      dateRanges: dateRanges ?? this.dateRanges,
      isGenerating: isGenerating ?? this.isGenerating,
      viewCounts: viewCounts ?? this.viewCounts,
      lastViewedAt: lastViewedAt ?? this.lastViewedAt,
    );
  }
}

class ReportsNotifier extends StateNotifier<ReportsState> {
  ReportsNotifier() : super(const ReportsState());

  void cacheReportData(String reportKey, Object? data) {
    final next = Map<String, Object?>.from(state.cachedData);
    next[reportKey] = data;
    state = state.copyWith(cachedData: next);
  }

  T? getCachedReportData<T>(String reportKey) {
    final value = state.cachedData[reportKey];
    return value is T ? value : null;
  }

  void setDateRange(String reportKey, DateTimeRange range) {
    final next = Map<String, DateTimeRange>.from(state.dateRanges);
    next[reportKey] = range;
    state = state.copyWith(dateRanges: next);
  }

  DateTimeRange? getDateRange(String reportKey) => state.dateRanges[reportKey];

  void trackReportView(String reportKey) {
    final counts = Map<String, int>.from(state.viewCounts);
    counts[reportKey] = (counts[reportKey] ?? 0) + 1;

    final viewed = Map<String, DateTime>.from(state.lastViewedAt);
    viewed[reportKey] = DateTime.now();

    state = state.copyWith(
      viewCounts: counts,
      lastViewedAt: viewed,
    );
  }

  bool isGeneratingFor(String reportKey) => state.isGenerating[reportKey] ?? false;

  Future<T> runReportGeneration<T>(String reportKey, Future<T> Function() task) async {
    final gen = Map<String, bool>.from(state.isGenerating);
    gen[reportKey] = true;
    state = state.copyWith(isGenerating: gen);

    try {
      return await task();
    } finally {
      final done = Map<String, bool>.from(state.isGenerating);
      done[reportKey] = false;
      state = state.copyWith(isGenerating: done);
    }
  }
}

final reportsProvider = StateNotifierProvider<ReportsNotifier, ReportsState>((ref) {
  return ReportsNotifier();
});
