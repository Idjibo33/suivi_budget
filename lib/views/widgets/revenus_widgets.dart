import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class RevenusWidgets extends StatelessWidget {
  final int totalRevenus;
  const RevenusWidgets({super.key, required this.totalRevenus});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Revenus", style: Styles.texteCorps),
          Text(
            "${totalRevenus.toString()} F CFA",
            style: Styles.texteTitre.copyWith(color: Styles.couleurRevenu),
          ),
        ],
      ),
    );
  }
}
