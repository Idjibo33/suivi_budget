import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Transactions/Revenus/revenu_categorie_card.dart';

class RevenusCategorieSection extends StatelessWidget {
  const RevenusCategorieSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenusCategoriesProvider>(
      builder: (context, value, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RevenuCategorieCard(
                icone: Icons.money,
                titre: "Salaire",
                couleure: Styles.couleurRevenu,
                choisie: value.categorie == "Salaire" ? true : false,
              ),
              RevenuCategorieCard(
                icone: Icons.money,
                titre: "Aide",
                couleure: Styles.couleurRevenu,
                choisie: value.categorie == "Aide" ? true : false,
              ),
              RevenuCategorieCard(
                icone: Icons.money,
                titre: "Freelance",
                couleure: Styles.couleurRevenu,
                choisie: value.categorie == "Freelance" ? true : false,
              ),
              RevenuCategorieCard(
                icone: Icons.money,
                titre: "Remboursement",
                couleure: Styles.couleurRevenu,
                choisie: value.categorie == "Remboursement" ? true : false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
