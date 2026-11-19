import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
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
        EtatListeErreur(message: final message) =>
          Center(child: Text(message)),
        EtatListeVide() =>
          const Center(child: Text('Aucune transaction trouvée')),
        EtatListePret(transactions: final transactions) => ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) =>
                TransactionCard(transaction: transactions[index]),
          ),
      },
    );
  }
}
