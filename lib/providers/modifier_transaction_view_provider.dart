import 'package:flutter/material.dart';
import 'package:suivi_budget/models/etats/etat_detail_transaction.dart';

class ModifierTransactionViewProvider extends ChangeNotifier {
  EtatDetailTransaction _etat = EtatDetailTransaction.consultation;

  EtatDetailTransaction get etat => _etat;

  // alias conservé pour les widgets existants
  bool get showview => _etat == EtatDetailTransaction.edition;

  void changer() => _appliquer(_etat.basculer());

  void afficherEdition() => _appliquer(EtatDetailTransaction.edition);

  void afficherConsultation() => _appliquer(EtatDetailTransaction.consultation);

  void _appliquer(EtatDetailTransaction etat) {
    _etat = etat;
    notifyListeners();
  }
}
