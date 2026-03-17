import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to track whether sensitive financial amounts (money) should be visible or masked.
/// true = visible, false = masked (e.g., ****)
final amountsVisibilityProvider = StateProvider<bool>((ref) => true);
