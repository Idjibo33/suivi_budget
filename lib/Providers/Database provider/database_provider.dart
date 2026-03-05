import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/database/transaction_dao.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/success_snackbar.dart';
import 'package:suivi_budget/models/helpers/validation.dart';
import 'package:suivi_budget/models/transaction.dart';

class DatabaseProvider extends ChangeNotifier {
  final TransactionDao database;
  DatabaseProvider({required this.database});

  Stream<List<Transaction>> get transactions => database.getTransactions();
  bool _chargement = false;
  bool get chargement => _chargement;
  String _message = '';

  Future<void> addTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) async {
    try {
      _chargement = true;
      notifyListeners();
      await database.addTransaction(transaction);
      _chargement = false;
      _message = "Transaction ajoutée avec succès";
      notifyListeners();
      if (context.mounted) showSuccessSnackbar(context, _message);
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }

  Future<void> updateTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) async {
    try {
      _chargement = true;
      notifyListeners();
      await database.editTransaction(transaction);
      _chargement = false;
      _message = "Transaction modifiée avec succès";
      notifyListeners();
      if (context.mounted) showSuccessSnackbar(context, _message);
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }

  Future<void> delteTransaction(BuildContext context, {required int id}) async {
    try {
      _chargement = true;
      notifyListeners();
      await database.deleteTransaction(id);
      _chargement = false;
      _message = "Transaction supprimé avec succès";
      notifyListeners();
      if (context.mounted) showSuccessSnackbar(context, _message);
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }
}
