import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/services/local_auth.dart';

void main() {
  test('canCheckBiometrics indisponible : retourne false sans lever',
      () async {
    expect(await LocalAuth().checkLocalAuthAvailable(), isFalse);
  });

  test('estUtilisable retourne false sans binding initialisé', () async {
    expect(await LocalAuth().estUtilisable(), isFalse);
  });

  test('authenticated retourne false quand la biométrie est indisponible',
      () async {
    expect(await LocalAuth().authenticated(description: 'test'), isFalse);
  });
}
