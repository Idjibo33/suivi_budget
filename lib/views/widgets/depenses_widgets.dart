import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

class DepensesWidgets extends StatelessWidget {
  const DepensesWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dépenses", style: Styles.texteCorps),

          Text(
            "Depense",
            style: Styles.texteTitre.copyWith(color: Styles.couleurDepense),
          ),
        ],
      ),
    );
  }
}
