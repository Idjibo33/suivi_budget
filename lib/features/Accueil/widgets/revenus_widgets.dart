import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/features/Accueil/widgets/ajouter_transaction_widget.dart';
import 'package:suivi_budget/providers.dart';

class RevenusWidgets extends StatelessWidget {
  const RevenusWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    int sommesRevenus = context.watch<DatabaseProvider>().totalRevenus();
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
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sommesRevenus.toString(),
                  style: Styles.texteTitre.copyWith(color: Colors.white),
                ),
                IconButton.filled(
                  onPressed: () {
                    showModalBottomSheet(
                      useSafeArea: true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const AjouterTransaction(
                        typeTransaction: TypeTransaction.revenus,
                      ),
                    );
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
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
