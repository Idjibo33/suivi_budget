import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class DepensesWidgets extends StatelessWidget {
  final int totalDepenses;
  const DepensesWidgets({super.key, required this.totalDepenses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dépenses", style: Styles.texteCorps),
          Text(
            "${totalDepenses.toString()} F CFA",
            style: Styles.texteTitre.copyWith(color: Styles.couleurDepense),
          ),
        ],
      ),
    );
  }
}
