import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.money, color: Colors.grey, size: 20),
                  ),
                ),
                Text(transaction.category, style: Styles.texteTitre),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  transaction.type == TypeTransaction.revenus
                      ? "+${transaction.montant.toString()}"
                      : "-${transaction.montant.toString()}",
                  style: Styles.texteTitre.copyWith(
                    color: transaction.type == TypeTransaction.revenus
                        ? Styles.couleurRevenu
                        : Styles.couleurDepense,
                  ),
                ),
                Text(
                  transaction.date.toString(),
                  style: Styles.texteCorps.copyWith(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
