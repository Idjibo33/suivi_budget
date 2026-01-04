import 'package:floor/floor.dart';
import 'package:suivi_budget/database/transaction.dart';

@dao
abstract class TransactionDao {
  //Lire toutes les transaction
  @Query('SELECT * FROM transaction_table')
  Future<List<Transaction>> toutesLesTransactions();

  //Ajouter une transaction
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> ajouterTransaction(Transaction transaction);

  //Mettre à jour une transaction
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> misAJourtransaction(Transaction transaction);

  //Supprimer une transaction
  @Query('DELETE FROM transaction WHERE id = :id')
  Future<void> supprimerTransactionParId(int id);
}
