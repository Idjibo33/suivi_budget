import 'package:flutter/material.dart';
import 'package:suivi_budget/views/transactions/formulaire_transaction_widget.dart';

/// Écran de création d'une dépense : le formulaire commun est paramétré par type.
class AjouterDepenseView extends StatelessWidget {
  const AjouterDepenseView({super.key});

  @override
  Widget build(BuildContext context) {
    return const FormulaireTransactionWidget(type: 'Depense');
  }
}
