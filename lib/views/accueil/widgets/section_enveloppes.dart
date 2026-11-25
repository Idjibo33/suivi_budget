import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/budgets/widgets/budget_card.dart';
import 'package:suivi_budget/views/budgets/widgets/modeles_budget.dart';

/// Contenu principal de l'accueil : les enveloppes encore actives.
///
/// Le tap sur une carte ouvre le détail via l'écran Budgets existant ; en
/// l'absence d'enveloppe, la carte vide et son CTA créent un budget. Les deux
/// chemins réutilisent les widgets de l'écran Budgets, sans état propre ici.
class SectionEnveloppes extends StatelessWidget {
  const SectionEnveloppes({super.key});

  /// Le détail est porté par l'écran Budgets : une seule navigation à entretenir.
  void ouvrirBudgets(BuildContext context, {int? id}) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => BudgetsScreen(budgetInitialId: id),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) {
        final List<Budget> budgets = database.budgets;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('Mes budgets', style: Styles.texteTitre),
                  ),
                ),
                TextButton(
                  onPressed: () => ouvrirBudgets(context),
                  child: const Text('Gérer'),
                ),
              ],
            ),
            const Gap(8),
            if (budgets.isEmpty)
              const ModelesBudget()
            else ...[
              Text(
                budgets.length == 1
                    ? '1 budget actif'
                    : '${budgets.length} budgets actifs',
                style: Styles.texteCorps.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Styles.texteSecondaire(context),
                ),
              ),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (final budget in budgets)
                    BudgetCard(
                      budget: budget,
                      totaux: database.totauxDuBudget(budget),
                      selectionnee: false,
                      onTap: () => ouvrirBudgets(context, id: budget.id),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
