import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/helpers/icone_type_transaction.dart';

/// Sélection d'une vraie catégorie de la base. Le sens de la transaction est
/// imposé par la liste reçue : aucune catégorie de revenu n'est proposée pour
/// une dépense.
class CategorieSection extends StatelessWidget {
  final List<Categorie> categories;
  final int? categorieChoisieId;
  final ValueChanged<Categorie> choixVal;

  const CategorieSection({
    super.key,
    required this.categories,
    required this.categorieChoisieId,
    required this.choixVal,
  });

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return Text(
        'Aucune catégorie disponible pour ce type de transaction.',
        style: Styles.texteCorps.copyWith(
          color: Styles.texteSecondaire(context),
        ),
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final Categorie categorie in categories)
          ChoiceChip(
            label: Text(categorie.nom),
            avatar: Icon(
              iconeTypeTransaction(categorie.typeCategorie),
              size: 16,
            ),
            selected: categorie.id == categorieChoisieId,
            onSelected: (_) => choixVal(categorie),
          ),
      ],
    );
  }
}
