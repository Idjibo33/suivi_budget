import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/transaction_details_view.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  String formaterDate(String date) {
    final DateTime? dateTime = DateTime.tryParse(date);
    if (dateTime == null) {
      return date;
    }
    return DateFormat('dd/MM/yyyy', 'fr_FR').format(dateTime);
  }

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
              Expanded(
                child: Row(
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
                    Flexible(
                      child: Text(
                        transaction.category,
                        style: Styles.texteTitre,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
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
                      formaterDate(transaction.date),
                      style: Styles.texteCorps.copyWith(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
