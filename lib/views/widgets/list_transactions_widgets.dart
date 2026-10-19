import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) {
        if (database.listChargement) {
          return const Center(child: CircularProgressIndicator());
        }

        final String? erreur = database.listErreur;
        if (erreur != null) {
          return Center(child: Text(erreur));
        }

        final List<Transaction> transactions = database.transactionsListe;
        if (transactions.isEmpty) {
          return const Center(child: Text("Aucune transaction trouvée"));
        }

        return ListView.builder(
          itemCount: transactions.length,
          itemBuilder: (BuildContext context, int index) {
            return TransactionCard(transaction: transactions[index]);
          },
        );
      },
    );
  }
}
