import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_provider.dart';
import 'package:suivi_budget/constants.dart';

class RevenuCategorieCard extends StatelessWidget {
  final bool choisie;
  final Color couleure;
  final IconData icone;
  final String titre;
  const RevenuCategorieCard({
    super.key,
    required this.icone,
    required this.titre,
    required this.couleure,
    required this.choisie,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenusCategoriesProvider>(
      builder: (context, value, child) => SizedBox(
        width: 90,
        child: Tooltip(
          message: titre,
          child: GestureDetector(
            onTap: () => value.changerCategorie(titre),
            child: Card(
              shadowColor: couleure,
              elevation: choisie ? 4 : 0,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Icon(icone, color: couleure),
                    Text(
                      titre,
                      style: Styles.texteCorps,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
