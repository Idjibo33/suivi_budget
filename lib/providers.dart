import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/database/transaction.dart';
import 'package:suivi_budget/database/transaction_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseProvider extends ChangeNotifier {
  final TransactionDao dao;
  List<Transaction> transactions = [];

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

class UtilisateurInfoProvider extends ChangeNotifier {
  String? nom;
  static const String key = "nom_utilisateur";

  //Ajouter nom de l'utilisateur
  void ajouterNom(String n) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, n);
    nom = n;
    notifyListeners();
  }

  //Lire nom de l'utilisateur
  Future<void> lireNom() async {
    final prefs = await SharedPreferences.getInstance();
    nom = prefs.getString(key) ?? "Utilisateur";
    notifyListeners();
  }
}
