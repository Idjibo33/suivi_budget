import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/body_texte.dart';
import 'package:suivi_budget/Core/titre_texte.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/transaction_details_view.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => TransactionDetailsView(transaction: transaction),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: couleurbgSecondaire,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.money,
                        color: transaction.type == "Revenu"
                            ? couleurRevenu
                            : couleurDepense,
                        size: 20,
                      ),
                    ),
                  ),
                  TitreTexte(texte: transaction.category),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TitreTexte(
                    texte: transaction.montant.toString(),
                    couleure: transaction.type == "Revenu"
                        ? couleurRevenu
                        : couleurDepense,
                  ),
                  BodyTexte(texte: transaction.date.toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
