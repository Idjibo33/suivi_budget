import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_liste_transactions.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => switch (database.etatListe) {
        EtatListeChargement() =>
          const Center(child: CircularProgressIndicator()),
        EtatListeErreur(message: final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Styles.texteCorps.copyWith(
                  color: Styles.texteSecondaire(context),
                ),
              ),
            ),
          ),
        EtatListeVide() => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 40,
                    color: Styles.texteSecondaire(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Aucune transaction trouvée',
                    style: Styles.texteCorps.copyWith(
                      color: Styles.texteSecondaire(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        EtatListePret(transactions: final transactions) => ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) =>
                TransactionCard(transaction: transactions[index]),
          ),
      },
    );
  }
}
