import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Configure sqflite sur desktop.
///
/// Android et iOS continuent d'utiliser le plugin sqflite natif : remplacer la
/// factory FFI sur mobile casserait l'accès à la base existante.
void configureDatabaseFactory() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
