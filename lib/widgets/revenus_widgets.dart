import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/providers.dart';
import 'package:suivi_budget/widgets/ajouter_transaction.dart';

class RevenusWidgets extends StatelessWidget {
  const RevenusWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    int SommesRevenus = context.watch<DatabaseProvider>().totalRevenus();
    return Card(
      color: Colors.green.shade200,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Revenus",
              style: Styles.texteCorps.copyWith(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  SommesRevenus.toString(),
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
                        typeTransaction: TypeTransaction.revenus,
                      ),
                    );
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Styles.couleurRevenu,
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
