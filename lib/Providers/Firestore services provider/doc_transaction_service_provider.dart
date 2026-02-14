import 'package:flutter/widgets.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/document_transaction_service.dart';
import 'package:suivi_budget/models/transaction.dart';

class DocTransactionServiceProvider extends ChangeNotifier {
  final DocumentTransactionService _documentTransactionService =
      DocumentTransactionService();
  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;
  String get message => _message;
  // Creer le document transaction
  Future<bool> creerDocTransaction(TransactionModel transaction) async {
    _chargement = true;
    notifyListeners();
    try {
      final resultat = await _documentTransactionService.creerDocTransaction(
        transaction,
      );
      _chargement = false;
      notifyListeners();
      if (resultat != null) {
        _message = "Transaction enregistré avec succès";
        return true;
      } else {
        _message = "Une erreur est survenue";
        notifyListeners();
        return false;
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      return false;
    }
  }
}
