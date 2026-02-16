import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_provider.dart';
import 'package:suivi_budget/constants.dart';

class DepenseCategorieCard extends StatelessWidget {
  final bool choisie;
  final Color couleure;
  final IconData icone;
  final String titre;
  const DepenseCategorieCard({
    super.key,
    required this.icone,
    required this.titre,
    required this.couleure,
    required this.choisie,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DepensesCategoriesProvider>(
      builder: (context, value, child) => SizedBox(
        width: 90,
        child: Tooltip(
          message: titre,
          child: GestureDetector(
            onTap: () => value.changerCategorie(titre),
            child: Card(
              elevation: choisie ? 4 : 0,
              shadowColor: couleure,
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
