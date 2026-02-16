import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';

class TransactionDetailsView extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    String date =
        "${DateFormat.yMMMMEEEEd().format(transaction.date)} à ${DateFormat.Hm().format(transaction.date)}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.money_outlined,
                size: 40,
                color: transaction.type == "Revenu"
                    ? Styles.couleurRevenu
                    : Styles.couleurDepense,
              ),
            ),
          ),
          Text(transaction.category, style: Styles.texteTitre),
          Text(
            transaction.montant.toString(),
            style: Styles.texteTitre.copyWith(
              color: transaction.type == "Revenu"
                  ? Styles.couleurRevenu
                  : Styles.couleurDepense,
            ),
          ),

          Text(transaction.description, style: Styles.texteCorps),
          Text(date),
        ],
      ),
    );
  }
}
