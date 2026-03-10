import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:suivi_budget/Providers/Database%20services%20provider/transaction_table_provider.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionTableProvider>(
      builder: (context, value, child) => StreamBuilder(
        stream: value.transaction,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData && snapshot.data!.isEmpty ||
              snapshot.data == null) {
            return Center(child: Text("Aucun document trouvé"));
          } else {
            return Skeletonizer(
              enabled: snapshot.connectionState == ConnectionState.waiting,
              child: ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (BuildContext context, int index) {
                  return TransactionCard(transaction: snapshot.data![index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}
