import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Garde la configuration Android cohérente : le manifeste `.MainActivity`
/// est résolu par le `namespace` Gradle, pas par le `applicationId` des flavors.
void main() {
  test('le package de MainActivity correspond au namespace Android', () {
    final File gradle = File('android/app/build.gradle.kts');
    final File manifeste = File('android/app/src/main/AndroidManifest.xml');
    final File activite = File(
      'android/app/src/main/kotlin/com/mybudget/app/MainActivity.kt',
    );

    expect(gradle.existsSync(), isTrue, reason: 'build.gradle.kts introuvable');
    expect(manifeste.existsSync(), isTrue, reason: 'AndroidManifest introuvable');
    expect(
      activite.existsSync(),
      isTrue,
      reason: 'MainActivity doit être dans le package du namespace',
    );

    final String contenuGradle = gradle.readAsStringSync();
    final String? namespace = RegExp(r'namespace\s*=\s*"([^"]+)"')
        .firstMatch(contenuGradle)
        ?.group(1);

    expect(namespace, 'com.mybudget.app');
    expect(activite.readAsStringSync(), contains('package $namespace'));
    expect(
      manifeste.readAsStringSync(),
      contains('android:name=".MainActivity"'),
    );
    expect(
      File(
        'android/app/src/main/kotlin/com/example/suivi_budget/MainActivity.kt',
      ).existsSync(),
      isFalse,
      reason: 'ancien package laissé sur le disque',
    );
  });
}
