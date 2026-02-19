import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/Transaction%20services/doc_transaction.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocTransactionProvider extends ChangeNotifier {
  final DocTransaction _documentTransaction = DocTransaction();
  Stream<List<TransactionModel>> get transactions =>
      _documentTransaction.lireDocsTransactions();

  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;
  // Creer le document transaction
  Future creerDocTransaction(
    TransactionModel transaction,
    BuildContext context,
  ) async {
    _chargement = true;
    notifyListeners();
    try {
      await _documentTransaction.creerDocTransaction(transaction);
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
  Future supprimerDoc(BuildContext context, String id) async {
    _chargement = true;
    notifyListeners();
    try {
      await _documentTransaction.supprimerTransaction(id);
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
  Future modifierDoc({
    required BuildContext context,
    required TransactionModel transaction,
  }) async {
    _chargement = true;
    notifyListeners();
    try {
      await _documentTransaction.modifierTransaction(
        transactionModifiee: transaction,
      );
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
}
