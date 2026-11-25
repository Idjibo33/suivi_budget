import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/modele_budget.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/widgets/creer_budget_dialog.dart';

Future<void> ouvrirCreationBudgetAvecModeles(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 0.75,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: ModelesBudget(fermerApresCreation: true),
        ),
      ),
    );

class ModelesBudget extends StatelessWidget {
  const ModelesBudget({super.key, this.fermerApresCreation = false});

  final bool fermerApresCreation;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<DatabaseProvider>();
    final personnels = database.modelesBudget;

    Future<void> utiliser([ModeleBudget? modele]) async {
      final cree = await showDialog<bool>(
        context: context,
        builder: (_) => CreerBudgetDialog(modele: modele),
      );
      if (cree == true && fermerApresCreation && context.mounted) {
        Navigator.pop(context);
      }
    }

    void modifier([ModeleBudget? modele]) => showDialog<void>(
      context: context,
      builder: (_) => CreerBudgetDialog(
        modele: modele,
        enregistrerModele: (dialogue, resultat) =>
            database.enregistrerModelesBudget(dialogue, [
              for (final item in personnels)
                identical(item, modele) ? resultat : item,
              if (modele == null) resultat,
            ]),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choisissez un modèle pour commencer, puis définissez votre plafond.',
          style: Styles.texteCorps.copyWith(
            fontWeight: FontWeight.w400,
            color: Styles.texteSecondaire(context),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final modele in ModeleBudget.suggestions)
              OutlinedButton(
                onPressed: () => utiliser(modele),
                child: Text(modele.nom),
              ),
          ],
        ),
        if (personnels.isNotEmpty) const Text('Mes modèles'),
        for (final modele in personnels)
          ListTile(
            title: Text(modele.nom),
            onTap: () => utiliser(modele),
            trailing: PopupMenuButton<String>(
              tooltip: 'Gérer le modèle',
              onSelected: (action) {
                if (action == 'modifier') {
                  modifier(modele);
                } else {
                  database.enregistrerModelesBudget(context, [
                    for (final item in personnels)
                      if (!identical(item, modele)) item,
                  ]);
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'modifier', child: Text('Modifier')),
                PopupMenuItem(
                  value: 'supprimer',
                  child: Text('Supprimer le modèle'),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: utiliser,
          child: const Text('Créer un budget personnalisé'),
        ),
        TextButton(
          onPressed: modifier,
          child: const Text('Créer un modèle personnel'),
        ),
      ],
    );
  }
}
