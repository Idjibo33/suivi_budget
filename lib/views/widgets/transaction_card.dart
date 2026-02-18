import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/transaction_details_view.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => TransactionDetailsView(transaction: transaction),
      ),
      child: Card(
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
                      child: Icon(
                        Icons.money,
                        color: transaction.type == "Revenu"
                            ? Styles.couleurRevenu
                            : Styles.couleurDepense,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(transaction.category, style: Styles.texteTitre),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    transaction.montant.toString(),
                    style: Styles.texteTitre.copyWith(
                      color: transaction.type == "Revenu"
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
      ),
    );
  }
}
