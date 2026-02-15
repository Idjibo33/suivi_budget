import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

class DepensesWidgets extends StatelessWidget {
  const DepensesWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Dépenses",
              style: Styles.texteCorps.copyWith(color: Colors.white),
            ),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Depense",
                  style: Styles.texteTitre.copyWith(color: Colors.white),
                ),
                IconButton.filled(
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => AjouterTransaction(
                        typeTransaction: TypeTransaction.depenses,
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Styles.couleurDepense,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
