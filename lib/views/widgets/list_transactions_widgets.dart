import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final docsProvider = context.watch<DocTransactionProvider>();
    return StreamBuilder(
      stream: docsProvider.transaction,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }
        if (snapshot.hasData && snapshot.data!.isEmpty ||
            snapshot.data == null) {
          return Center(child: Text("Aucun document trouvé"));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length,
            itemBuilder: (BuildContext context, int index) {
              return TransactionCard(transaction: snapshot.data![index]);
            },
          );
        }
      },
    );
  }
}
