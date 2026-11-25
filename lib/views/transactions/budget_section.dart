import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';

/// Sélection de l'enveloppe sur laquelle la transaction sera imputée.
class BudgetSection extends StatelessWidget {
  final List<Budget> budgets;
  final int? budgetChoisiId;
  final ValueChanged<Budget> choixVal;

  const BudgetSection({
    super.key,
    required this.budgets,
    required this.budgetChoisiId,
    required this.choixVal,
  });

  @override
  Widget build(BuildContext context) {
    if (budgets.isEmpty) {
      return Text(
        'Créez d’abord un budget pour enregistrer une transaction.',
        style: Styles.texteCorps.copyWith(
          color: Styles.texteSecondaire(context),
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final Budget budget in budgets)
          ChoiceChip(
            label: Text(budget.nom),
            avatar: const Icon(Icons.account_balance_wallet_outlined, size: 16),
            selected: budget.id == budgetChoisiId,
            onSelected: (_) => choixVal(budget),
            tooltip: FormatMontant.afficherAvecDevise(budget.alloue),
          ),
      ],
    );
  }
}
