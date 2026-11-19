import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/models/etats/validation_transaction.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

class ModifierTransaction extends StatefulWidget {
  final Transaction transaction;
  const ModifierTransaction({super.key, required this.transaction});

  @override
  State<ModifierTransaction> createState() => _ModifierTransactionState();
}

class _ModifierTransactionState extends State<ModifierTransaction> {
  final TextEditingController montantText = TextEditingController();
  final TextEditingController descriptionText = TextEditingController();

  late DateTime date =
      DateTime.tryParse(widget.transaction.date) ?? DateTime.now();

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
          date: date,
          changementDate: (dateChoisie) => setState(() => date = dateChoisie),
        ),
        Consumer2<ModifierTransactionViewProvider, DatabaseProvider>(
          builder: (context, view, database, child) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => view.afficherConsultation(),
                  child: const Text("Annuler"),
                ),
              ),
              Expanded(
                child: CustomFilledButtonWidget(
                  texte: "Enregistrer",
                  action: () async {
                    final ResultatValidationMontant resultat =
                        validerMontant(montantText.text);
                    if (resultat is! MontantValide) {
                      showErrorSnackbar(
                        context,
                        (resultat as MontantInvalide).message,
                      );
                      return;
                    }
                    await database.updateTransaction(
                      context,
                      transaction: Transaction(
                        id: widget.transaction.id,
                        montant: resultat.montant,
                        category: widget.transaction.category,
                        description: descriptionText.text.trim(),
                        type: widget.transaction.type,
                        date: date.toString(),
                      ),
                    );
                    view.afficherConsultation();
                  },
                  chargement: database.chargement,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
