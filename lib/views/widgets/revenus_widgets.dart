import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:suivi_budget/constants.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Revenus", style: Styles.texteCorps),
          Skeletonizer(
            enabled: chargement,
            containersColor: Colors.grey,
            child: Text(
              "${totalRevenus.toString()} F CFA",
              style: Styles.texteTitre.copyWith(color: Styles.couleurRevenu),
            ),
          ),
        ],
      ),
    );
  }
}
