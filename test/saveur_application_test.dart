import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/etats/saveur_application.dart';

void main() {
  test('la saveur dev porte son nom et son identifiant', () {
    expect(SaveurApplication.depuisCode('dev'), SaveurApplication.dev);
    expect(SaveurApplication.dev.nomAffiche, 'MyBudget Dev');
    expect(SaveurApplication.dev.identifiant, 'com.mybudget.app.dev');
  });

  test('la saveur prod est le repli par défaut', () {
    expect(SaveurApplication.depuisCode('prod'), SaveurApplication.prod);
    expect(SaveurApplication.depuisCode(''), SaveurApplication.prod);
    expect(SaveurApplication.depuisCode('inconnu'), SaveurApplication.prod);
    expect(SaveurApplication.prod.nomAffiche, 'MyBudget');
    expect(SaveurApplication.prod.identifiant, 'com.mybudget.app');
  });
}
