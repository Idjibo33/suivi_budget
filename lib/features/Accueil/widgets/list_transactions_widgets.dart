import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/features/Accueil/widgets/transaction_card.dart';
import 'package:suivi_budget/providers.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    String monFiltre = context.watch<DatabaseProvider>().filtre;

    return Expanded(
      child: Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          if (monFiltre == "revenus") {
            return ListView.builder(
              itemCount: value.transactionsRevenus.length,
              itemBuilder: (context, index) => TransactionCard(
                transaction: value.transactionsRevenus[index],
              ),
            );
          } else if (monFiltre == "depenses") {
            return ListView.builder(
              itemCount: value.transactionsDepenses.length,
              itemBuilder: (context, index) => TransactionCard(
                transaction: value.transactionsDepenses[index],
              ),
            );
          }
          return ListView.builder(
            itemCount: value.transactions.length,
            itemBuilder: (context, index) =>
                TransactionCard(transaction: value.transactions[index]),
          );
        },
      ),
    );
  }
}
