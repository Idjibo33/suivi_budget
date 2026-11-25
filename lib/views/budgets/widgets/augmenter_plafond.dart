import 'package:flutter/material.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/providers/database_provider.dart';

Future<bool> proposerHaussePlafond(
  BuildContext context,
  DatabaseProvider database,
  Budget budget,
  DateTime date,
) async {
  final actuel = database.totauxDuBudget(budget, maintenant: date).alloue;
  String saisie = '';
  final montant = await showDialog<int>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Augmenter le plafond · ${budget.nom}'),
      content: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: 'Nouveau plafond',
          helperText: 'Plus de ${FormatMontant.afficherAvecDevise(actuel)}',
        ),
        onChanged: (texte) => saisie = texte,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () {
            final nouveau = FormatMontant.lire(saisie);
            if (nouveau != null && nouveau > actuel) {
              Navigator.pop(context, nouveau);
            }
          },
          child: const Text('Augmenter'),
        ),
      ],
    ),
  );
  if (montant == null || !context.mounted) return false;
  return database.augmenterPlafond(context, budget, montant, date);
}
