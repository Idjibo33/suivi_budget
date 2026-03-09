import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransactionTable implements Databaseervices<TransactionModel> {
  final _supabase = Supabase.instance.client;
  final String transactionsTable = "transactions";
  @override
  Future<void> createData(TransactionModel item) {
    return _supabase.from(transactionsTable).insert(item);
  }

  @override
  Future<void> deleteData(String id) {
    return _supabase.from(transactionsTable).delete().eq('id', id);
  }

  @override
  Stream<List<TransactionModel>> readData() {
    return _supabase.from(transactionsTable).stream(primaryKey: ['id']).map((
      event,
    ) {
      return event.map((e) => TransactionModel.fromMap(e)).toList();
    });
  }

  @override
  Future<dynamic> readDataOnce() {
    // TODO: implement readDataOnce
    throw UnimplementedError();
  }

  @override
  Future<dynamic> updateData(TransactionModel item) {
    return _supabase.from(transactionsTable).update(item.toMap());
  }
}
