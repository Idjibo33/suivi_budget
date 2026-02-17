import 'package:flutter/material.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_service_provider.dart';
import 'package:suivi_budget/models/transaction.dart';

class SoldeProvider extends ChangeNotifier {
  final DocTransactionServiceProvider _docTransactionsServices =
      DocTransactionServiceProvider();
  List<TransactionModel> _transactions = [];
  bool _chargement = false;
  bool get chargement => _chargement;

  bool _visible = false;
  bool get visible => _visible;
  void changervisiblite() {
    _visible = !_visible;
    notifyListeners();
  }

  // La liste des transactions
  void listTransaction() {
    _chargement = true;
    _docTransactionsServices.transactions.listen((event) {
      _transactions = event;
      _chargement = false;
      notifyListeners();
    });
  }

  // le total des revenus
  int totalRevenus() {
    return _transactions
        .where((element) => element.type == "Revenu")
        .fold(0, (previousValue, element) => previousValue + element.montant);
  }

  // le total des depenses
  int totalDepenses() {
    return _transactions
        .where((element) => element.type == "Depense")
        .fold(0, (previousValue, element) => previousValue + element.montant);
  }

  //Calculer le solde total
  int soldeTotal() {
    return totalRevenus() - totalDepenses();
  }
}
