import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/database/transaction_dao.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/success_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';

class DatabaseProvider extends ChangeNotifier {
  final TransactionDao database;
  DatabaseProvider({required this.database});

  List<Transaction> _transactionsListe = [];
  List<Transaction> get transactionsListe => _transactionsListe;

  bool _listChargement = true;
  bool get listChargement => _listChargement;

  String? _listErreur;
  String? get listErreur => _listErreur;

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
      log('Error in addTransaction: $e');
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

  void listenTransactions() {
    database.getTransactions().listen(
      (event) {
        _transactionsListe = event;
        _listChargement = false;
        _listErreur = null;
        notifyListeners();
      },
      onError: (Object error) {
        log('Error in listenTransactions: $error');
        _listChargement = false;
        _listErreur = "Impossible de charger les transactions";
        notifyListeners();
      },
    );
  }

  // le total des revenus
  int totalRevenus() {
    return _transactionsListe
        .where((element) => element.type == "Revenu")
        .fold(0, (previousValue, element) => previousValue + element.montant);
  }

  // le total des depenses
  int totalDepenses() {
    return _transactionsListe
        .where((element) => element.type == "Depense")
        .fold(0, (previousValue, element) => previousValue + element.montant);
  }

  //Calculer le solde total
  int soldeTotal() {
    return totalRevenus() - totalDepenses();
  }
}
