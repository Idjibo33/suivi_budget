import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';
import 'package:suivi_budget/models/etats/type_categorie.dart';
import 'package:suivi_budget/models/helpers/calcul_budget.dart';

LigneBudget ligne(int montant, TypeCategorie type, String date) =>
    (montant: montant, type: type, date: date);

void main() {
  final DateTime maintenant = DateTime(2026, 11, 22, 10);

  test('la période mensuelle ne compte que le mois courant', () {
    final TotauxBudget totaux = calculerTotaux(
      alloue: 300000,
      periode: const PeriodeMensuelle(),
      maintenant: maintenant,
      lignes: [
        ligne(1000, TypeCategorie.revenu, '2026-11-02T08:00:00'),
        ligne(400, TypeCategorie.depense, '2026-11-03T08:00:00'),
        ligne(5000, TypeCategorie.depense, '2026-10-03T08:00:00'),
      ],
    );

    expect(totaux.apporte, 1000);
    expect(totaux.depense, 400);
    expect(totaux.disponible, 300600);
  });

  test('la période libre borne les dates inclusivement', () {
    final PeriodeBudget periode = PeriodeBudget.depuisCode(
      'libre',
      debut: '2026-10-01',
      fin: '2026-10-31',
    );
    final TotauxBudget totaux = calculerTotaux(
      alloue: 150000,
      periode: periode,
      maintenant: maintenant,
      lignes: [
        ligne(2000, TypeCategorie.revenu, '2026-10-01T00:00:00'),
        ligne(500, TypeCategorie.depense, '2026-10-31T23:59:59'),
        ligne(900, TypeCategorie.depense, '2026-11-01T00:00:00'),
      ],
    );

    expect(totaux.apporte, 2000);
    expect(totaux.depense, 500);
    expect(totaux.disponible, 151500);
  });

  test('un revenu n’est jamais compté comme une dépense', () {
    final TotauxBudget totaux = calculerTotaux(
      alloue: 100000,
      periode: const PeriodeMensuelle(),
      maintenant: maintenant,
      lignes: [
        ligne(75000, TypeCategorie.revenu, '2026-11-05T09:00:00'),
      ],
    );

    expect(totaux.apporte, 75000);
    expect(totaux.depense, 0);
    expect(totaux.disponible, 175000);
  });

  test('une date invalide est ignorée sans casser le calcul', () {
    final TotauxBudget totaux = calculerTotaux(
      alloue: 1000,
      periode: const PeriodeMensuelle(),
      maintenant: maintenant,
      lignes: [
        ligne(500, TypeCategorie.depense, 'pas-une-date'),
        ligne(200, TypeCategorie.depense, '2026-11-10T09:00:00'),
      ],
    );

    expect(totaux.depense, 200);
    expect(totaux.disponible, 800);
  });
}
