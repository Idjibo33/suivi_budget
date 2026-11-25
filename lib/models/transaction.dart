import 'package:floor/floor.dart';

import 'etats/type_categorie.dart';

/// Modèle affiché par l'application.
///
/// Ce n'est pas une entité Floor : le type et le nom de catégorie proviennent
/// de la jointure avec `categories_table` faite par le DAO. Le type n'est donc
/// jamais stocké sur la transaction elle-même.
@DatabaseView('''
  SELECT t.id AS id,
         t.montant AS montant,
         c.nom AS category,
         c.type AS type,
         t.description AS description,
         t.date AS date,
         t.categorie_id AS categorieId,
         t.budget_id AS budgetId,
         t.created_at AS createdAt,
         t.updated_at AS updatedAt
  FROM transactions_table AS t
  INNER JOIN categories_table AS c ON t.categorie_id = c.id
''', viewName: 'transactions_affichees')
class Transaction {
  Transaction({
    this.id,
    required this.montant,
    required this.category,
    required this.type,
    required this.description,
    required this.date,
    this.categorieId = 0,
    this.budgetId,
    String? createdAt,
    String? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now().toIso8601String(),
       updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  final int? id;
  final int montant;

  /// Nom de la catégorie, issu de la jointure.
  final String category;

  /// Code de type issu de la catégorie : `'Revenu'` ou `'Depense'`.
  final String type;

  final String description;
  final String date;
  final int categorieId;
  final int? budgetId;
  final String createdAt;
  final String updatedAt;

  /// Le sens est déduit du type de la catégorie, jamais stocké ici.
  TypeCategorie get typeCategorie => TypeCategorie.depuisCode(type);

  bool get estRevenu => typeCategorie == TypeCategorie.revenu;

  bool get estDepense => typeCategorie == TypeCategorie.depense;
}
