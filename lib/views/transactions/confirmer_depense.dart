import 'package:flutter/material.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/widgets/augmenter_plafond.dart';

Future<bool> confirmerDepense(
  BuildContext context,
  DatabaseProvider database, {
  required Budget? budget,
  required int montant,
  required DateTime date,
  Transaction? ancienne,
}) async {
  final soldeAvantDepense =
      database.soldeTotal() +
      switch (ancienne) {
        null => 0,
        final transaction when transaction.estDepense => transaction.montant,
        final transaction => -transaction.montant,
      };
  bool plafondDepasse() =>
      budget != null &&
      montant >
          database
              .totauxDuBudget(
                budget,
                maintenant: date,
                transactionIgnoree: ancienne?.id,
              )
              .disponible;
  if (budget != null && plafondDepasse() && !budget.depassementAutorise) {
    final augmente = await proposerHaussePlafond(
      context,
      database,
      budget,
      date,
    );
    if (!context.mounted || !augmente || plafondDepasse()) return false;
  }
  final depassePlafond = plafondDepasse();
  final depasseSolde =
      montant > soldeAvantDepense &&
      (ancienne == null || ancienne.estRevenu || montant > ancienne.montant);
  if (depasseSolde || depassePlafond) {
    final continuer = await showDialog<bool>(
      context: context,
      builder: (dialogue) => AlertDialog(
        title: const Text('Vérifier la dépense'),
        content: Text(
          [
            if (depasseSolde)
              'Cette dépense rendra votre solde global négatif.',
            if (depassePlafond) 'Cette dépense dépasse le plafond du budget.',
          ].join('\n'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogue, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogue, true),
            child: const Text('Enregistrer quand même'),
          ),
        ],
      ),
    );
    if (!context.mounted || continuer != true) return false;
  }

  return true;
}
