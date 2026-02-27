import 'package:flutter/material.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/Services/Local%20Auth/local_auth.dart';
import 'package:suivi_budget/models/transaction.dart';

class SoldeProvider extends ChangeNotifier {
  final DocTransactionProvider _docTransactions = DocTransactionProvider();
  List<TransactionModel> _transactions = [];
  bool _chargement = false;
  bool get chargement => _chargement;
  final LocalAuth _localAuth = LocalAuth();

  bool _visible = false;
  bool get visible => _visible;
  void changervisiblite() async {
    if (!_visible) {
      final authentification = await _localAuth.authenticated();
      if (authentification) {
        _visible = !_visible;
      }
    } else {
      _visible = !_visible;
      notifyListeners();
    }
  }

  // La liste des transactions
  void listTransaction() {
    _chargement = true;
    _docTransactions.transactions.listen((event) {
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
