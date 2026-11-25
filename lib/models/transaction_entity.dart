import 'package:floor/floor.dart';

import 'budget.dart';
import 'categorie.dart';

/// Ligne stockée en base. Le sens de la transaction n'est pas dupliqué :
/// il est déduit de la catégorie via la jointure dans le DAO.
@Entity(
  tableName: 'transactions_table',
  foreignKeys: [
    ForeignKey(
      childColumns: ['categorie_id'],
      parentColumns: ['id'],
      entity: Categorie,
      onDelete: ForeignKeyAction.restrict,
    ),
    ForeignKey(
      childColumns: ['budget_id'],
      parentColumns: ['id'],
      entity: Budget,
      onDelete: ForeignKeyAction.restrict,
    ),
  ],
)
class TransactionEntity {
  TransactionEntity({
    this.id,
    required this.montant,
    required this.categorieId,
    required this.budgetId,
    required this.description,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) : date = date ?? DateTime.now().toIso8601String(),
       createdAt = createdAt ?? DateTime.now().toIso8601String(),
       updatedAt = updatedAt ?? DateTime.now().toIso8601String();

  @primaryKey
  @ColumnInfo(name: 'id')
  final int? id;

  /// Toujours positif : le signe affiché vient du type de la catégorie.
  @ColumnInfo(name: 'montant')
  final int montant;

  @ColumnInfo(name: 'categorie_id')
  final int categorieId;

  @ColumnInfo(name: 'budget_id')
  final int? budgetId;

  @ColumnInfo(name: 'description')
  final String description;

  @ColumnInfo(name: 'date')
  final String date;

  @ColumnInfo(name: 'created_at')
  final String createdAt;

  @ColumnInfo(name: 'updated_at')
  final String updatedAt;

  TransactionEntity avecHorodatageMiseAJour() => TransactionEntity(
    id: id,
    montant: montant,
    categorieId: categorieId,
    budgetId: budgetId,
    description: description,
    date: date,
    createdAt: createdAt,
    updatedAt: DateTime.now().toIso8601String(),
  );
}
