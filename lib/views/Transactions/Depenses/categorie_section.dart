import 'package:flutter/material.dart';
import 'package:suivi_budget/models/categorie_card.dart';
import 'package:suivi_budget/views/widgets/categorie_card.dart';

/// La catégorie choisie appartient au formulaire parent : ce widget
/// affiche la sélection et notifie les changements sans dupliquer l'état.
class CategorieSection extends StatelessWidget {
  final String? categorieChoisie;
  final String typeCategorie;
  final ValueChanged<String> choixVal;

  const CategorieSection({
    super.key,
    required this.categorieChoisie,
    required this.typeCategorie,
    required this.choixVal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            for (final categorie
                in typeCategorie == "Revenu"
                    ? revenusCategories
                    : depensesCategories)
              CategorieCard(
                catChoisie: choixVal,
                card: categorie,
                choisie: categorie.titre == categorieChoisie,
              ),
          ],
        ),
      ],
    );
  }
}
