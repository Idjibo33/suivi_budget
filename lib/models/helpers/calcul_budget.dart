import '../etats/periode_budget.dart';
import '../etats/type_categorie.dart';

/// Ligne ramenée au domaine : le type vient de la catégorie, pas de la transaction.
typedef LigneBudget = ({int montant, TypeCategorie type, String date});

/// Totaux d'une enveloppe sur sa période active.
class TotauxBudget {
  const TotauxBudget({
    required this.alloue,
    required this.apporte,
    required this.depense,
  });

  final int alloue;
  final int apporte;
  final int depense;

  /// L'alloué initial n'est jamais écrasé : les revenus s'y ajoutent.
  int get disponible => alloue + apporte - depense;
}

/// Calcule apporté et dépensé en ne retenant que les lignes de la période.
TotauxBudget calculerTotaux({
  required int alloue,
  required PeriodeBudget periode,
  required Iterable<LigneBudget> lignes,
  DateTime? maintenant,
}) {
  final DateTime reference = maintenant ?? DateTime.now();
  int apporte = 0;
  int depense = 0;

  for (final LigneBudget ligne in lignes) {
    final DateTime? date = DateTime.tryParse(ligne.date);
    if (date == null || !_dansLaPeriode(date, periode, reference)) {
      continue;
    }
    switch (ligne.type) {
      case TypeCategorie.revenu:
        apporte += ligne.montant;
      case TypeCategorie.depense:
        depense += ligne.montant;
    }
  }

  return TotauxBudget(alloue: alloue, apporte: apporte, depense: depense);
}

bool _dansLaPeriode(
  DateTime date,
  PeriodeBudget periode,
  DateTime reference,
) =>
    switch (periode) {
      PeriodeMensuelle() =>
        date.year == reference.year && date.month == reference.month,
      PeriodeLibre(:final DateTime debut, :final DateTime fin) =>
        !date.isBefore(debut) && !date.isAfter(_finDeJournee(fin)),
    };

DateTime _finDeJournee(DateTime date) =>
    DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
