import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/models/categorie_card.dart';

class CategorieCard extends StatelessWidget {
  final Function(String val) catChoisie;
  final bool choisie;
  final CategorieCardModel card;
  const CategorieCard({
    super.key,
    required this.card,
    required this.choisie,
    required this.catChoisie,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Tooltip(
        message: card.titre,
        child: GestureDetector(
          onTap: () => catChoisie(card.titre),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(30),
            ),
            shadowColor: card.type == "Revenu" ? couleurRevenu : couleurDepense,
            elevation: choisie ? 4 : 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Icon(
                    Icons.money_outlined,
                    color: card.type == "Revenu"
                        ? couleurRevenu
                        : couleurDepense,
                  ),
                  Text(
                    card.titre,
                    style: texteCorps.copyWith(
                      color: card.type == "Revenu"
                          ? couleurRevenu
                          : couleurDepense,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
