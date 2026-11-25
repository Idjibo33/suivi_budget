import 'package:floor/floor.dart';

import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/models/transaction_entity.dart';

/// Accès aux trois tables V2. `Transaction` est un modèle de lecture issu de
/// la jointure : le type d'une transaction vient toujours de sa catégorie.
@dao
abstract class TransactionDao {
  // ---------- Transactions ----------

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> addTransactionEntity(TransactionEntity transaction);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> editTransactionEntity(TransactionEntity transaction);

  @Query('DELETE FROM transactions_table WHERE id = :id')
  Future<void> deleteTransaction(int id);

  // ---------- Paramètres locaux ----------

  @Query('SELECT valeur FROM parametres_table WHERE cle = :cle')
  Future<String?> lireParametre(String cle);

  @Query('''
    INSERT INTO parametres_table (cle, valeur) VALUES (:cle, :valeur)
    ON CONFLICT(cle) DO UPDATE SET valeur = excluded.valeur
  ''')
  Future<void> ecrireParametre(String cle, String valeur);

  @Query('SELECT * FROM transactions_affichees ORDER BY date DESC')
  Stream<List<Transaction>> getTransactions();

  /// Pont avec l'ancien appelant : le modèle de lecture est converti en entité.
  Future<void> addTransaction(Transaction transaction) =>
      addTransactionEntity(_entite(transaction));

  /// La modification rafraîchit `updated_at` sans toucher à `created_at`.
  Future<void> editTransaction(Transaction transaction) =>
      editTransactionEntity(_entite(transaction).avecHorodatageMiseAJour());

  TransactionEntity _entite(Transaction transaction) => TransactionEntity(
        id: transaction.id,
        montant: transaction.montant,
        categorieId: transaction.categorieId,
        budgetId: transaction.budgetId,
        description: transaction.description,
        date: transaction.date,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
      );

  // ---------- Catégories ----------

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<void> addCategorie(Categorie categorie);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> editCategorieBrute(Categorie categorie);

  /// Toute modification rafraîchit `updated_at`, même via un appel direct.
  Future<void> editCategorie(Categorie categorie) =>
      editCategorieBrute(categorie.avecHorodatageMiseAJour());

  @Query('SELECT * FROM categories_table WHERE archive = 0 ORDER BY nom ASC')
  Stream<List<Categorie>> getCategories();

  @Query('SELECT * FROM categories_table ORDER BY nom ASC')
  Stream<List<Categorie>> getToutesCategories();

  @Query('SELECT COUNT(*) FROM transactions_table WHERE categorie_id = :id')
  Future<int?> nombreTransactionsCategorie(int id);

  // ---------- Budgets ----------

  @Insert(onConflict: OnConflictStrategy.abort)
  Future<void> addBudget(Budget budget);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> editBudgetBrute(Budget budget);

  /// Toute modification rafraîchit `updated_at`, même via un appel direct.
  Future<void> editBudget(Budget budget) =>
      editBudgetBrute(budget.avecHorodatageMiseAJour());

  @Query('SELECT * FROM budgets_table WHERE archive = 0 ORDER BY nom ASC')
  Stream<List<Budget>> getBudgets();

  /// Toutes les enveloppes, y compris archivées, pour l'onglet « Archivés ».
  @Query('SELECT * FROM budgets_table ORDER BY nom ASC')
  Stream<List<Budget>> getToutBudgets();

  @Query('SELECT COUNT(*) FROM transactions_table WHERE budget_id = :id')
  Future<int?> nombreTransactionsBudget(int id);
}
