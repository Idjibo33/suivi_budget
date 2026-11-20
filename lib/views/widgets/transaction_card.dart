import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
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
    final bool estRevenu = transaction.type == "Revenu";
    final Color couleurMontant = estRevenu
        ? Styles.couleurRevenu(context)
        : Styles.couleurDepense(context);

    return InkWell(
      onTap: () => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) => TransactionDetailsView(transaction: transaction),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Styles.bordure(context), width: 1),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Styles.surfaceSecondaire(context),
              ),
              child: Icon(
                estRevenu ? Icons.arrow_upward : Icons.arrow_downward,
                size: 19,
                color: couleurMontant,
              ),
            ),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.category,
                    style: Styles.texteTitre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Gap(2),
                  Text(
                    formaterDate(transaction.date),
                    style: Styles.texteCorps.copyWith(
                      fontSize: 12,
                      color: Styles.texteSecondaire(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Gap(8),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  FormatMontant.afficherAvecSigne(
                    transaction.montant,
                    estRevenu: estRevenu,
                    devise: false,
                  ),
                  style: Styles.texteMontantCompact.copyWith(
                    color: couleurMontant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
