import 'package:floor/floor.dart';
import 'package:suivi_budget/models/transaction.dart';

@dao
abstract class TransactionDao {
  @Insert(onConflict: OnConflictStrategy.ignore)
  Future<void> addTransaction(Transaction transaction);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> editTransaction(Transaction transaction);

  @Query('DELETE FROM transactions_table WHERE id = :id')
  Future<void> deleteTransaction(int id);

  @Query("SELECT * FROM transactions_table")
  Stream<List<Transaction>> getTransactions();
}
