import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to control the current mode of the SaleScreen (new | history)
final saleScreenModeProvider = StateProvider<String>((ref) => 'new');
