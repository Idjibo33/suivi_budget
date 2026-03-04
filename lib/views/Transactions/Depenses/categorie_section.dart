import 'package:flutter/material.dart';
import 'package:suivi_budget/models/categorie_card.dart';
import 'package:suivi_budget/views/widgets/categorie_card.dart';

class CategorieSection extends StatefulWidget {
  final Function(String? val) choixVal;
  final String typeCategorie;
  const CategorieSection({
    super.key,
    required this.typeCategorie,
    required this.choixVal,
  });

  @override
  State<CategorieSection> createState() => _CategorieSectionState();
}

class _CategorieSectionState extends State<CategorieSection> {
  String? categorieValue;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            for (final categorie
                in widget.typeCategorie == "Revenu"
                    ? revenusCategories
                    : depensesCategories)
              CategorieCard(
                catChoisie: (val) => setState(() {
                  categorieValue = val;
                  widget.choixVal(val);
                }),
                card: categorie,
                choisie: categorie.titre == categorieValue ? true : false,
              ),
          ],
        ),
      ],
    );
  }
}
