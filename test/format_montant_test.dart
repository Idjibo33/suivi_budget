import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';

void main() {
  test('regroupe les milliers selon la locale française', () {
    final String formatte = FormatMontant.afficher(12500);

    expect(formatte, isNot(contains('12,500')));
    expect(FormatMontant.nettoyer(formatte), '12500');
    expect(FormatMontant.lire(formatte), 12500);
  });

  test('le signe et la devise sont optionnels', () {
    expect(
      FormatMontant.afficherAvecSigne(1000, estRevenu: true, devise: false),
      '+${FormatMontant.afficher(1000)}',
    );
    expect(
      FormatMontant.afficherAvecSigne(500, estRevenu: false, devise: false),
      '-${FormatMontant.afficher(500)}',
    );
    expect(
      FormatMontant.afficherAvecSigne(1000, estRevenu: true),
      '+${FormatMontant.afficher(1000)} F CFA',
    );
    expect(FormatMontant.afficherAvecDevise(2000), contains('F CFA'));
  });

  test('la saisie ignore les espaces de regroupement', () {
    expect(FormatMontant.lire('1\u202F000'), 1000);
    expect(FormatMontant.lire('1\u00A0000'), 1000);
    expect(FormatMontant.lire(' 10 000 '), 10000);
    expect(FormatMontant.lire('-3'), -3);
    expect(FormatMontant.lire('abc'), isNull);
  });

  test('les montants suggérés sont positifs et uniques', () {
    expect(FormatMontant.suggestions, isNotEmpty);
    expect(FormatMontant.suggestions.every((montant) => montant > 0), isTrue);
    expect(
      FormatMontant.suggestions.toSet().length,
      FormatMontant.suggestions.length,
    );
  });
}
