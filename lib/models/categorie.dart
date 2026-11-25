import 'package:floor/floor.dart';

import 'etats/type_categorie.dart';

/// Catégorie de transaction : détermine le sens de la transaction.
@Entity(tableName: 'categories_table')
class Categorie {
  Categorie({
    this.id,
    required this.nom,
    String? type,
    this.famille = 'Autre',
    this.icone = 'i-wallet',
    this.motif = 'pat-points',
    this.personnalisee = false,
    this.archive = false,
    String? createdAt,
    String? updatedAt,
  })  : type = type ?? TypeCategorie.depense.libelle,
        createdAt = createdAt ?? DateTime.now().toIso8601String(),
        updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  @primaryKey
  @ColumnInfo(name: 'id')
  final int? id;

  @ColumnInfo(name: 'nom')
  final String nom;

  /// Code issu de [TypeCategorie.libelle] : `'Revenu'` ou `'Depense'`.
  @ColumnInfo(name: 'type')
  final String type;

  /// Utilisée uniquement pour regrouper les catégories dans les graphiques.
  @ColumnInfo(name: 'famille')
  final String famille;

  @ColumnInfo(name: 'icone')
  final String icone;

  @ColumnInfo(name: 'motif')
  final String motif;

  @ColumnInfo(name: 'personnalisee')
  final bool personnalisee;

  @ColumnInfo(name: 'archive')
  final bool archive;

  @ColumnInfo(name: 'created_at')
  final String createdAt;

  @ColumnInfo(name: 'updated_at')
  final String updatedAt;

  TypeCategorie get typeCategorie => TypeCategorie.depuisCode(type);

  /// Transition nommée : rafraîchir l'horodatage sans toucher à la création.
  Categorie avecHorodatageMiseAJour() => Categorie(
        id: id,
        nom: nom,
        type: type,
        famille: famille,
        icone: icone,
        motif: motif,
        personnalisee: personnalisee,
        archive: archive,
        createdAt: createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

  Categorie renommer(String nouveauNom) => Categorie(
        id: id,
        nom: nouveauNom.trim(),
        type: type,
        famille: famille,
        icone: icone,
        motif: motif,
        personnalisee: true,
        archive: archive,
        createdAt: createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );

  Categorie archiver() => Categorie(
        id: id,
        nom: nom,
        type: type,
        famille: famille,
        icone: icone,
        motif: motif,
        personnalisee: personnalisee,
        archive: true,
        createdAt: createdAt,
        updatedAt: DateTime.now().toIso8601String(),
      );
}
