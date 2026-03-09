import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/transaction.dart';

class TransactionTable implements Databaseervices<TransactionModel> {
  @override
  Future<dynamic> createData(TransactionModel item) {
    // TODO: implement createData
    throw UnimplementedError();
  }

  @override
  Future<dynamic> deleteData(String id) {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionModel>> readData() {
    // TODO: implement readData
    throw UnimplementedError();
  }

  @override
  Future<dynamic> readDataOnce() {
    // TODO: implement readDataOnce
    throw UnimplementedError();
  }

  @override
  Future<dynamic> updateData(String id, TransactionModel item) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
