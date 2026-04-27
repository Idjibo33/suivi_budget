import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Core/widgets/body_texte.dart';
import 'package:suivi_budget/Core/widgets/titre_texte.dart';
import 'package:suivi_budget/Features/transactions/logic/providers/database_provider.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/transaction_card.dart';

class ListTransactionsWidgets extends StatelessWidget {
  const ListTransactionsWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => StreamBuilder(
        stream: database.transactions,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: TitreTexte(texte: 'snapshot.error.toString()'),
            );
          }

          if (snapshot.hasData && snapshot.data!.isEmpty ||
              snapshot.data == null) {
            return Center(
              child: const BodyTexte(texte: "Aucune transaction à afficher"),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return TransactionCard(transaction: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
