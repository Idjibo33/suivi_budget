import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/widgets/body_texte.dart';
import 'package:suivi_budget/Core/widgets/titre_texte.dart';
import 'package:suivi_budget/Core/constants.dart';

class RevenusWidgets extends StatelessWidget {
  final bool chargement;
  final int totalRevenus;
  const RevenusWidgets({
    super.key,
    required this.totalRevenus,
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
              child: Icon(Icons.arrow_downward_sharp, color: couleurRevenu),
            ),
          ),
          Column(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BodyTexte(texte: "Revenus"),
              TitreTexte(
                texte: "${totalRevenus.toString()} F CFA",
                couleure: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
