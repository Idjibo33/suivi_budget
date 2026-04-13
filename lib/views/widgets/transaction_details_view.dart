import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/Core/widgets/custom_text_button_widget.dart';
import 'package:suivi_budget/views/widgets/modifier_transaction.dart';

class TransactionDetailsView extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetailsView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    bool view = context.watch<ModifierTransactionViewProvider>().showview;
    //String dateTransaction =
    //  "${DateFormat.yMMMMEEEEd().format(transaction.date)} à ${DateFormat.Hm().format(transaction.date)}";
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
                          ? couleurRevenu
                          : couleurDepense,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Montant :", style: texteCorps),
                    Text(
                      transaction.montant.toString(),
                      style: texteTitre.copyWith(
                        color: transaction.type == "Revenu"
                            ? couleurRevenu
                            : couleurDepense,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Type de transaction :", style: texteCorps),
                    Text(
                      transaction.type,
                      style: texteTitre.copyWith(
                        color: transaction.type == "Revenu"
                            ? couleurRevenu
                            : couleurDepense,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Catégorie :", style: texteCorps),
                    Text(
                      transaction.category,
                      style: texteTitre.copyWith(
                        color: transaction.type == "Revenu"
                            ? couleurRevenu
                            : couleurDepense,
                      ),
                    ),
                  ],
                ),
                Text(transaction.description, style: texteTitre),
                Text("", style: texteCorps),
                !view
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Consumer<DatabaseProvider>(
                            builder: (context, database, child) => Expanded(
                              child: CustomTextButtonWidget(
                                couleurTexte: couleurDepense,
                                texte: "Supprimer",
                                action: () async {
                                  await database.delteTransaction(
                                    context,
                                    id: transaction.id!,
                                  );
                                  if (context.mounted) Navigator.pop(context);
                                },
                                chargement: false,
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
