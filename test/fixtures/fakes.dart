import 'dart:async';

import 'package:suivi_budget/Services/Local%20Auth/local_auth.dart';
import 'package:suivi_budget/Services/database/transaction_dao.dart';
import 'package:suivi_budget/models/transaction.dart';

class FakeTransactionDao implements TransactionDao {
  final StreamController<List<Transaction>> _controller =
      StreamController<List<Transaction>>.broadcast();
  final List<Transaction> added = [];
  final List<Transaction> updated = [];
  final List<int> deleted = [];

  Future<void> emit(List<Transaction> transactions) async {
    _controller.add(transactions);
    await Future<void>.value();
  }

  Future<void> emitError(Object error) async {
    _controller.addError(error);
    await Future<void>.value();
  }

  Future<void> close() => _controller.close();

  @override
  Future<void> addTransaction(Transaction transaction) async {
    added.add(transaction);
  }

  @override
  Future<void> editTransaction(Transaction transaction) async {
    updated.add(transaction);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    deleted.add(id);
  }

  @override
  Stream<List<Transaction>> getTransactions() => _controller.stream;
}

class FakeLocalAuth extends LocalAuth {
  FakeLocalAuth({this.result = true});

  bool result;
  int authenticationCalls = 0;

  @override
  Future<bool> checkLocalAuthAvailable() async => result;

  @override
  Future<bool> authenticated({required String description}) async {
    authenticationCalls++;
    return result;
  }
}

Transaction buildTransaction({
  int? id,
  int montant = 1000,
  String category = 'Salaire',
  String description = 'Description',
  String type = 'Revenu',
  String date = '2026-10-19 08:00:00.000',
}) {
  return Transaction(
    id: id,
    montant: montant,
    category: category,
    description: description,
    type: type,
    date: date,
  );
}
