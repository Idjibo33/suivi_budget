import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20services%20provider/transaction_table_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/navigation/naviguer_page_recente.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/custom_text_button_widget.dart';
import 'package:suivi_budget/views/widgets/modifier_transaction.dart';

class TransactionDetailsView extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool view = context.watch<ModifierTransactionViewProvider>().showview;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 16.0,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Text(transaction.date, style: Styles.texteCorps),
                Text(transaction.id.toString(), style: Styles.texteCorps),
                !view
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<TransactionTableProvider>(
                            builder: (context, transactions, child) => Expanded(
                              child: CustomTextButtonWidget(
                                couleurTexte: Styles.couleurDepense,
                                texte: "Supprimer",
                                action: () async {
                                  await transactions.deleteTransactionRow(
                                    context,
                                    transaction.id!,
                                  );
                                  if (context.mounted) {
                                    naviguerPagerecente(context);
                                  }
                                },
                                chargement: transactions.chargement,
                              ),
                            ),
                          ),
                          Consumer<ModifierTransactionViewProvider>(
                            builder: (context, value, child) => Expanded(
                              child: FilledButton(
                                onPressed: () => value.changer(),
                                child: Text("Modifier"),
                              ),
                            ),
                          ),
                        ],
                      )
                    : SizedBox(),
                view ? Divider() : SizedBox(),
                view
                    ? ModifierTransaction(transaction: transaction)
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
