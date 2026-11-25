import 'package:floor/floor.dart';

import 'etats/periode_budget.dart';

/// Enveloppe à dépenser. L'alloué initial n'est jamais écrasé par les revenus.
@Entity(tableName: 'budgets_table')
class Budget {
  Budget({
    this.id,
    required this.nom,
    required this.alloue,
    String? typePeriode,
    this.dateDebut,
    this.dateFin,
    this.icone = 'i-wallet',
    this.motif = 'pat-plein',
    this.archive = false,
    this.depassementAutorise = false,
    String? createdAt,
    String? updatedAt,
  }) : typePeriode = typePeriode ?? const PeriodeMensuelle().code,
       createdAt = createdAt ?? DateTime.now().toIso8601String(),
       updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  @primaryKey
  @ColumnInfo(name: 'id')
  final int? id;

  @ColumnInfo(name: 'nom')
  final String nom;

  @ColumnInfo(name: 'alloue')
  final int alloue;

  /// `'mensuel'` ou `'libre'`, issu de [PeriodeBudget.code].
  @ColumnInfo(name: 'type_periode')
  final String typePeriode;

  @ColumnInfo(name: 'date_debut')
  final String? dateDebut;

  @ColumnInfo(name: 'date_fin')
  final String? dateFin;

  @ColumnInfo(name: 'icone')
  final String icone;

  @ColumnInfo(name: 'motif')
  final String motif;

  @ColumnInfo(name: 'archive')
  final bool archive;

  @ColumnInfo(name: 'depassement_autorise')
  final bool depassementAutorise;

  @ColumnInfo(name: 'created_at')
  final String createdAt;

  @ColumnInfo(name: 'updated_at')
  final String updatedAt;

  /// La période est reconstituée à la lecture, jamais dupliquée dans la transaction.
  PeriodeBudget get periode =>
      PeriodeBudget.depuisCode(typePeriode, debut: dateDebut, fin: dateFin);

  /// Variante tolérante pour l'affichage et les totaux : une ligne incohérente
  /// ne doit jamais faire planter l'écran.
  PeriodeBudget? get periodeValide {
    try {
      return periode;
    } on ArgumentError {
      return null;
    }
  }

  Budget changerAutorisationDepassement(bool autorise) => Budget(
    id: id,
    nom: nom,
    alloue: alloue,
    typePeriode: typePeriode,
    dateDebut: dateDebut,
    dateFin: dateFin,
    icone: icone,
    motif: motif,
    archive: archive,
    depassementAutorise: autorise,
    createdAt: createdAt,
  );

  /// Transition nommée : rafraîchir l'horodatage sans toucher à la création.
  Budget avecHorodatageMiseAJour() => Budget(
    id: id,
    nom: nom,
    alloue: alloue,
    typePeriode: typePeriode,
    dateDebut: dateDebut,
    dateFin: dateFin,
    icone: icone,
    motif: motif,
    archive: archive,
    depassementAutorise: depassementAutorise,
    createdAt: createdAt,
    updatedAt: DateTime.now().toIso8601String(),
  );

  /// Transition nommée : une enveloppe archivée sort des budgets actifs.
  Budget archiver() => Budget(
    id: id,
    nom: nom,
    alloue: alloue,
    typePeriode: typePeriode,
    dateDebut: dateDebut,
    dateFin: dateFin,
    icone: icone,
    motif: motif,
    archive: true,
    depassementAutorise: depassementAutorise,
    createdAt: createdAt,
    updatedAt: DateTime.now().toIso8601String(),
  );

  /// Transition nommée : une enveloppe archivée revient parmi les budgets
  /// actifs, sans changer son identité ni sa date de création.
  Budget desarchiver() => Budget(
    id: id,
    nom: nom,
    alloue: alloue,
    typePeriode: typePeriode,
    dateDebut: dateDebut,
    dateFin: dateFin,
    icone: icone,
    motif: motif,
    archive: false,
    depassementAutorise: depassementAutorise,
    createdAt: createdAt,
    updatedAt: DateTime.now().toIso8601String(),
  );
}
