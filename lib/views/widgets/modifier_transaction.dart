import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/Transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/Transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

class ModifierTransaction extends StatefulWidget {
  final Transaction transaction;
  const ModifierTransaction({super.key, required this.transaction});

  @override
  State<ModifierTransaction> createState() => _ModifierTransactionState();
}

class _ModifierTransactionState extends State<ModifierTransaction> {
  //Les controlleurs des champs des textes pour modifier
  TextEditingController montantText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();

  @override
  void initState() {
    super.initState();
    montantText.text = widget.transaction.montant.toString();
    descriptionText.text = widget.transaction.description;
  }

  @override
  void dispose() {
    montantText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        CustomMontantTextfield(montantController: montantText),

        CustomTextfieldWidget(
          label: "Description",
          typeInput: TextInputType.text,
          controlleurChamp: descriptionText,
          icone: Icons.text_fields_rounded,
        ),
        DateTransactionCard(
          changementDate: (dateChoisie) => date = dateChoisie,
        ),
        Consumer2<ModifierTransactionViewProvider, DatabaseProvider>(
          builder: (context, view, database, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => view.changer(),
                  child: Text("Annuler"),
                ),
              ),
              Expanded(
                child: CustomFilledButtonWidget(
                  texte: "Enregistrer",
                  action: () async {
                    await database.updateTransaction(
                      context,
                      transaction: widget.transaction,
                    );
                    view.changer();
                  },
                  chargement: false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
