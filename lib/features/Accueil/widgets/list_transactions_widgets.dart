import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/database_provider.dart';
import 'package:suivi_budget/features/Accueil/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          return ListView.builder(
            itemCount: value.listFiltree.length,
            itemBuilder: (context, index) =>
                TransactionCard(transaction: value.listFiltree[index]),
          );
        },
      ),
    );
  }
}
