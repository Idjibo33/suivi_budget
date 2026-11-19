import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/database/transaction_dao.dart';
import 'package:suivi_budget/models/etats/etat_liste_transactions.dart';
import 'package:suivi_budget/models/etats/etat_operation.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/success_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';

class DatabaseProvider extends ChangeNotifier {
  final TransactionDao database;
  DatabaseProvider({required this.database});

  EtatListeTransactions _etatListe = const EtatListeChargement();
  EtatOperation _etatOperation = const EtatOperationInerte();

  EtatListeTransactions get etatListe => _etatListe;
  EtatOperation get etatOperation => _etatOperation;

  // alias conservés pour les widgets et tests existants
  bool get listChargement => _etatListe.enChargement;
  String? get listErreur => _etatListe.messageErreur;
  List<Transaction> get transactionsListe => _etatListe.liste;
  bool get chargement => _etatOperation.enCours;

  Future<void> addTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) =>
      _executer(
        context: context,
        etiquette: 'addTransaction',
        messageSucces: 'Transaction ajoutée avec succès',
        action: () => database.addTransaction(transaction),
      );

  Future<void> updateTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) =>
      _executer(
        context: context,
        etiquette: 'updateTransaction',
        messageSucces: 'Transaction modifiée avec succès',
        action: () => database.editTransaction(transaction),
      );

  Future<void> delteTransaction(BuildContext context, {required int id}) =>
      _executer(
        context: context,
        etiquette: 'delteTransaction',
        messageSucces: 'Transaction supprimé avec succès',
        action: () => database.deleteTransaction(id),
      );

  Future<void> _executer({
    required BuildContext context,
    required String etiquette,
    required String messageSucces,
    required Future<void> Function() action,
  }) async {
    _changerOperation(const EtatOperationEnCours());
    try {
      await action();
      _changerOperation(EtatOperationSucces(messageSucces));
      if (context.mounted) showSuccessSnackbar(context, messageSucces);
    } catch (error) {
      log('Error in $etiquette: $error');
      _changerOperation(EtatOperationEchec(error.toString()));
      if (context.mounted) showErrorSnackbar(context, error.toString());
    }
  }

  void _changerOperation(EtatOperation etat) {
    _etatOperation = etat;
    notifyListeners();
  }

  void listenTransactions() {
    database.getTransactions().listen(
      (transactions) => _changerListe(etatListeApresFlux(transactions)),
      onError: (Object error) {
        log('Error in listenTransactions: $error');
        _changerListe(
          etatListeApresErreur(error, listePrecedente: _etatListe.liste),
        );
      },
    );
  }

  void _changerListe(EtatListeTransactions etat) {
    _etatListe = etat;
    notifyListeners();
  }

  int totalRevenus() {
    return _transactionsFiltrees('Revenu')
        .fold(0, (total, element) => total + element.montant);
  }

  int totalDepenses() {
    return _transactionsFiltrees('Depense')
        .fold(0, (total, element) => total + element.montant);
  }

  int soldeTotal() => totalRevenus() - totalDepenses();

  Iterable<Transaction> _transactionsFiltrees(String type) =>
      _etatListe.liste.where((transaction) => transaction.type == type);
}
