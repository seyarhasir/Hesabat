import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._();
  static final ConnectivityService instance = ConnectivityService._();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _onlineController = StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isOnline = true;

  bool get isOnline => _isOnline;
  Stream<bool> get onlineStream => _onlineController.stream;

  Future<void> initialize() async {
    final initial = await _connectivity.checkConnectivity();
    _setOnline(_containsOnline(initial));

    await _subscription?.cancel();
    _subscription = _connectivity.onConnectivityChanged.listen((results) {
      _setOnline(_containsOnline(results));
    });
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    await _onlineController.close();
  }

  bool _containsOnline(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.any((r) => r != ConnectivityResult.none);
  }

  void _setOnline(bool value) {
    if (_isOnline == value) return;
    _isOnline = value;
    _onlineController.add(value);
  }
}
