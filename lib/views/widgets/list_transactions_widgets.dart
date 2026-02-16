import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_service_provider.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final docsProvider = context.watch<DocTransactionServiceProvider>();
    return FutureBuilder(
      future: docsProvider.lireTransactions(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(docsProvider.message));
        }
        if (snapshot.hasData) {
          if (docsProvider.transaction.isEmpty) {
            return Center(child: Text("Aucun document trouvé"));
          }
        }
        return ListView.builder(
          itemCount: docsProvider.transaction.length,
          itemBuilder: (BuildContext context, int index) {
            return TransactionCard(
              transaction: docsProvider.transaction[index],
            );
          },
        );
      },
    );
  }
}
