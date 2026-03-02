import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/Services/transaction.dart';
import 'package:suivi_budget/Services/transaction_dao.dart';

class DatabaseProvider extends ChangeNotifier {
  final TransactionDao dao;
  List<Transaction> transactions = [];
  List<Transaction> listFiltree = [];
  String filtre = "toutes";

  DatabaseProvider({required this.dao});

  //Lire les transactions
  Future<void> lireTransactions() async {
    transactions = await dao.toutesLesTransactions();

    notifyListeners();
  }

  //Ajouter la transaction
  Future<void> ajouterTransaction(Transaction nouvelleTransaction) async {
    if (nouvelleTransaction.type == TypeTransaction.depenses) {
      int soldeActuel = calculerSolde();
      if (nouvelleTransaction.montant > soldeActuel) {
        throw "Votre solde est insuffisant";
      }
    }
    await dao.ajouterTransaction(nouvelleTransaction);
    await lireTransactions();
  }

  //Supprimer la transaction
  Future<void> supprimerTransaction(int id) async {
    await dao.supprimerTransactionParId(id);
    await lireTransactions();
  }

  //Mettre à jour la transaction
  Future<void> misAJourTransaction(Transaction transaction) async {
    await dao.misAJourtransaction(transaction);
    await lireTransactions();
  }

  //Changer la valeur du filtre
  void changerFiltre({required String nouveauFiltre}) {
    TypeTransaction filtreValue = nouveauFiltre == 'revenus'
        ? TypeTransaction.revenus
        : TypeTransaction.depenses;
    if (nouveauFiltre == "toutes") {
      filtre = nouveauFiltre;
      listFiltree = transactions;
      notifyListeners();
    } else {
      filtre = nouveauFiltre;
      notifyListeners();
      listFiltree = transactions
          .where((element) => element.type == filtreValue)
          .toList();
      notifyListeners();
    }
  }

  //Calculer la somme des revenus
  int totalRevenus() {
    int sommeRevenus = 0;
    for (var x in transactions.where(
      (element) => element.type == TypeTransaction.revenus,
    )) {
      sommeRevenus += x.montant;
    }
    return sommeRevenus;
  }

  //Calculer la somme des dépenses
  int totalDepenses() {
    int sommeDepenses = 0;
    for (var x in transactions.where(
      (element) => element.type == TypeTransaction.depenses,
    )) {
      sommeDepenses += x.montant;
    }
    return sommeDepenses;
  }

  //Calculer le solde
  int calculerSolde() {
    int revenus = totalRevenus();
    int depenses = totalDepenses();
    int soldeTotal = revenus - depenses;
    return soldeTotal;
  }
}
