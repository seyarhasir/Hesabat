import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Used when scanner is opened outside [SaleScreen] (e.g. global Home FAB).
/// Sale screen consumes this result and applies normal add-to-cart flow.
final pendingScannedBarcodeResultProvider =
    StateProvider<Map<String, dynamic>?>((ref) => null);
