import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/navigation/naviguer_page_recente.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';

class TransactionDetailsView extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    String date =
        "${DateFormat.yMMMMEEEEd().format(transaction.date)} à ${DateFormat.Hm().format(transaction.date)}";
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Montant :", style: Styles.texteCorps),
                  Text(
                    transaction.montant.toString(),
                    style: Styles.texteTitre.copyWith(
                      color: transaction.type == "Revenu"
                          ? Styles.couleurRevenu
                          : Styles.couleurDepense,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Type de transaction :", style: Styles.texteCorps),
                  Text(
                    transaction.type,
                    style: Styles.texteTitre.copyWith(
                      color: transaction.type == "Revenu"
                          ? Styles.couleurRevenu
                          : Styles.couleurDepense,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Catégorie :", style: Styles.texteCorps),
                  Text(
                    transaction.category,
                    style: Styles.texteTitre.copyWith(
                      color: transaction.type == "Revenu"
                          ? Styles.couleurRevenu
                          : Styles.couleurDepense,
                    ),
                  ),
                ],
              ),
              Text(transaction.description, style: Styles.texteTitre),
              Text(date, style: Styles.texteCorps),
              Consumer<DocTransactionProvider>(
                builder: (context, value, child) => CustomFilledButtonWidget(
                  texte: "Supprimer",
                  action: () {
                    value.supprimerDoc(context, transaction.id);
                    naviguerPagerecente(context);
                  },
                  chargement: value.chargement,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
