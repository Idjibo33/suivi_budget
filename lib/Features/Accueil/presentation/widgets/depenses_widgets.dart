import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/widgets/body_texte.dart';
import 'package:suivi_budget/Core/widgets/titre_texte.dart';
import 'package:suivi_budget/Core/constants.dart';

class DepensesWidgets extends StatelessWidget {
  final bool chargement;
  final int totalDepenses;
  const DepensesWidgets({
    super.key,
    required this.totalDepenses,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        spacing: 8,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.arrow_upward_sharp, color: couleurDepense),
            ),
          ),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyTexte(texte: "Dépenses"),
              TitreTexte(
                texte: "${totalDepenses.toString()} F CFA",
                couleure: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
