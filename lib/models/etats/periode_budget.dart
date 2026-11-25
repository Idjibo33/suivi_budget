import 'choix_periode_budget.dart';

/// Période d'une enveloppe budget, choisie explicitement par l'utilisateur.
///
/// [PeriodeMensuelle] ne porte aucune borne : le mois courant sert de filtre.
/// [PeriodeLibre] porte ses deux bornes, stockées en chaînes ISO dans la base.
sealed class PeriodeBudget {
  const PeriodeBudget();

  String get code;
  DateTime? get debut => null;
  DateTime? get fin => null;

  /// Reconstitue la période à partir de la colonne `type_periode` et des bornes.
  static PeriodeBudget depuisCode(String code, {String? debut, String? fin}) =>
      switch (code) {
        'mensuel' => const PeriodeMensuelle(),
        'libre' => PeriodeLibre.depuisChaines(debut, fin),
        _ => throw ArgumentError.value(code, 'code', 'Période de budget inconnue'),
      };

  /// Transition nommée utilisée par le formulaire de budget.
  PeriodeBudget changerPeriode({
    required ChoixPeriodeBudget choix,
    String? debut,
    String? fin,
  }) =>
      switch (choix) {
        ChoixPeriodeBudget.mensuel => const PeriodeMensuelle(),
        ChoixPeriodeBudget.libre => PeriodeLibre.depuisChaines(debut, fin),
      };
}

final class PeriodeMensuelle extends PeriodeBudget {
  const PeriodeMensuelle();

  @override
  String get code => 'mensuel';
}

final class PeriodeLibre extends PeriodeBudget {
  const PeriodeLibre(this.debut, this.fin);

  @override
  final DateTime debut;

  @override
  final DateTime fin;

  @override
  String get code => 'libre';

  factory PeriodeLibre.depuisChaines(String? debut, String? fin) {
    if (debut == null || fin == null) {
      throw ArgumentError('Une période libre exige une date de début et de fin');
    }
    final DateTime? debutParse = DateTime.tryParse(debut);
    final DateTime? finParse = DateTime.tryParse(fin);
    if (debutParse == null || finParse == null || debutParse.isAfter(finParse)) {
      throw ArgumentError('Bornes de période invalides');
    }
    return PeriodeLibre(debutParse, finParse);
  }
}
