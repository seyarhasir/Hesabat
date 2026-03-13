// Override package that re-exports sqlcipher_flutter_libs as sqlite3_flutter_libs
// This resolves the plugin registration conflict between sqlite3_flutter_libs
// and sqlcipher_flutter_libs which both define Sqlite3FlutterLibsPlugin

export 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

// Stub function to satisfy drift_flutter which expects this from sqlite3_flutter_libs
// This is a no-op for SQLCipher since it doesn't need the same workarounds
Future<void> applyWorkaroundToOpenSqlite3OnOldAndroidVersions() async {
  // No-op: SQLCipher doesn't require this workaround
  // This function is only needed for older Android versions with regular sqlite3
}
