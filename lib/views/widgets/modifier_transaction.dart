import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/auth_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/models/navigation/naviguer_page_recente.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/Transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/Transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

class ModifierTransaction extends StatefulWidget {
  final TransactionModel transaction;
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
    // L'id de l'utilisateur
    String idUtilisateur = context
        .watch<AuthProvider>()
        .authServices
        .currentUser!
        .uid;
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Consumer<ModifierTransactionViewProvider>(
                builder: (context, value, child) => TextButton(
                  onPressed: () => value.changer(),
                  child: Text("Annuler"),
                ),
              ),
            ),
            Consumer<DocTransactionProvider>(
              builder: (context, value, child) => Expanded(
                child: CustomFilledButtonWidget(
                  texte: "Enregistrer",
                  action: () async {
                    await value.modifierDoc(
                      context: context,
                      transaction: TransactionModel(
                        id: widget.transaction.id,
                        userId: idUtilisateur,
                        montant: int.parse(montantText.text.trim()),
                        category: widget.transaction.category,
                        description: descriptionText.text.trim(),
                        type: widget.transaction.type,
                        date: date,
                      ),
                    );
                    if (context.mounted) {
                      context.read<ModifierTransactionViewProvider>().changer();
                      naviguerPagerecente(context);
                    }
                  },
                  chargement: value.chargement,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
