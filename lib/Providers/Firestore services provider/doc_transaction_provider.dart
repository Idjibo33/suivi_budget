import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suivi_budget/Services/Firebase%20/Firestore%20services/doc_transaction.dart';
import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocTransactionProvider extends ChangeNotifier {
  final DocTransaction _documentTransaction = DocTransaction();
  List<TransactionModel> _listesTransactions = [];
  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;

  // Lire les transactions
  Stream<List<TransactionModel>> get _transactions =>
      _documentTransaction.readData();
  Stream<List<TransactionModel>> get transaction => _transactions;

  // Creer le document transaction
  Future createTransactionDoc({
    required TransactionModel transaction,
    required BuildContext context,
  }) async {
    try {
      final validation = validateBalance(soldeTotal(), transaction, context);
      if (!validation) {
        return;
      }

      _chargement = true;
      notifyListeners();
      await _documentTransaction.createData(transaction);
      _chargement = false;
      _message = "Transaction enregistré avec succès";
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, _message);
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) {
        showErrorSnackbar(context, _message);
      }
    }
  }

  // Supprimer le document transaction
  Future deleteTransactionDoc(BuildContext context, String id) async {
    _chargement = true;
    notifyListeners();
    try {
      await _documentTransaction.deleteData(id);
      _chargement = false;
      _message = "Supprimé avec succès";
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, _message);
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) {
        showErrorSnackbar(context, _message);
      }
    }
  }

  // Modifier la transaction
  Future updateTransactionDoc({
    required BuildContext context,
    required TransactionModel transaction,
  }) async {
    final validation = validateBalance(soldeTotal(), transaction, context);
    if (!validation) {
      return;
    }
    _chargement = true;
    notifyListeners();
    try {
      await _documentTransaction.updateData(transaction.id, transaction);
      _chargement = false;
      _message = "Modification réussie";
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, _message);
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) {
        showErrorSnackbar(context, _message);
      }
    }
  }

  // Suivre les transactions
  void subscribeTransactions() {
    _transactions.listen((event) {
      _listesTransactions = event;
      notifyListeners();
    });
  }

  // le total des revenus
  int totalRevenus() {
    return _listesTransactions
        .where((element) => element.type == "Revenu")
        .fold(0, (previousValue, element) => previousValue + element.montant);
  }

  // le total des depenses
  int totalDepenses() {
    return _listesTransactions
        .where((element) => element.type == "Depense")
        .fold(0, (previousValue, element) => previousValue + element.montant);
  }

  //Calculer le solde total
  int soldeTotal() {
    return totalRevenus() - totalDepenses();
  }
}
