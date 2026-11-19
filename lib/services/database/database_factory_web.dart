import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

// Sur le web, la base est stockée dans IndexedDB et propulsée par sqlite3
// compilé en WebAssembly (web/sqlite3.wasm et web/sqflite_sw.js).
void configureDatabaseFactory() {
  databaseFactory = databaseFactoryFfiWeb;
}
