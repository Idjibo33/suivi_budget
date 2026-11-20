import 'package:flutter/material.dart';
import 'package:suivi_budget/views/transactions/formulaire_transaction_widget.dart';

/// Écran de création d'un revenu : le formulaire commun est paramétré par type.
class AjouterRevenuView extends StatelessWidget {
  const AjouterRevenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormulaireTransactionWidget(type: 'Revenu');
  }
}
