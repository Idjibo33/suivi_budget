import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Transactions/Depenses/depense_categorie_card.dart';

class CategorieSection extends StatelessWidget {
  const CategorieSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DepensesCategoriesProvider>(
      builder: (context, value, child) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DepenseCategorieCard(
                icone: Icons.money,
                titre: "Courses",
                couleure: Styles.couleurDepense,
                choisie: value.categorie == "Courses" ? true : false,
              ),
              DepenseCategorieCard(
                icone: Icons.money,
                titre: "Loisirs",
                couleure: Styles.couleurDepense,
                choisie: value.categorie == "Loisirs" ? true : false,
              ),
              DepenseCategorieCard(
                icone: Icons.money,
                titre: "Transport",
                couleure: Styles.couleurDepense,
                choisie: value.categorie == "Transport" ? true : false,
              ),
              DepenseCategorieCard(
                icone: Icons.money,
                titre: "Abonnement",
                couleure: Styles.couleurDepense,
                choisie: value.categorie == "Abonnement" ? true : false,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
