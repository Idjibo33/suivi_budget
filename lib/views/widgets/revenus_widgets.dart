import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class RevenusWidgets extends StatelessWidget {
  const RevenusWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Revenus", style: Styles.texteCorps),

          Text(
            "Revenu",
            style: Styles.texteTitre.copyWith(color: Styles.couleurRevenu),
          ),
        ],
      ),
    );
  }
}
