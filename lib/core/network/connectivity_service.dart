import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService._internal()
      : _connectivity = Connectivity(),
        _checkConnectivityOverride = null {
    _primeStatus();
  }

  static final ConnectivityService instance = ConnectivityService._internal();

  final Connectivity _connectivity;
  final Future<List<ConnectivityResult>> Function()? _checkConnectivityOverride;
  bool _lastKnownOnline = true;

  ConnectivityService({
    Connectivity? connectivity,
    Future<List<ConnectivityResult>> Function()? checkConnectivity,
  })  : _connectivity = connectivity ?? Connectivity(),
        _checkConnectivityOverride = checkConnectivity;

  bool get isOnline => _lastKnownOnline;

  Stream<bool> get onlineStream {
    return _connectivity.onConnectivityChanged.map((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      _lastKnownOnline = online;
      return online;
    }).distinct();
  }

  Future<void> _primeStatus() async {
    _lastKnownOnline = await isOnlineNow();
  }

  Future<bool> isOnlineNow() async {
    final results = await (_checkConnectivityOverride?.call() ??
        _connectivity.checkConnectivity());
    final online = results.any((r) => r != ConnectivityResult.none);
    _lastKnownOnline = online;
    return online;
  }
}
