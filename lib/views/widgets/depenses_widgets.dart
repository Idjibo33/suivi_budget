import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dépenses", style: Styles.texteCorps),
          Skeletonizer(
            enabled: chargement,
            containersColor: Colors.grey,
            child: Text(
              "${totalDepenses.toString()} F CFA",
              style: Styles.texteTitre.copyWith(color: Styles.couleurDepense),
            ),
          ),
        ],
      ),
    );
  }
}
