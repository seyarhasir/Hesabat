import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';

export 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

// This MUST be called before any database access to redirect sqlite3 to sqlcipher
void setupSqlCipher() {
  if (Platform.isAndroid) {
    open.overrideFor(OperatingSystem.android, _openOnAndroid);
  }
}

DynamicLibrary _openOnAndroid() {
  try {
    return DynamicLibrary.open('libsqlcipher.so');
  } catch (_) {
    // Fallback if the above fails
    return DynamicLibrary.open('libsqlite3.so');
  }
}

// Stub function to satisfy drift_flutter which expects this from sqlite3_flutter_libs
Future<void> applyWorkaroundToOpenSqlite3OnOldAndroidVersions() async {
  setupSqlCipher();
}
