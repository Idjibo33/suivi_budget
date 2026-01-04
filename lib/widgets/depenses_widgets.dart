import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/providers.dart';
import 'package:suivi_budget/widgets/ajouter_transaction.dart';

class DepensesWidgets extends StatelessWidget {
  const DepensesWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    int sommesDepenses = context.watch<DatabaseProvider>().totalDepenses();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sommesDepenses.toString(),
                  style: Styles.texteTitre.copyWith(color: Colors.white),
                ),
                Gap(8),
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
