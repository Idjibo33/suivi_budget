import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/models/helpers/check_solde.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/custom_montant_textfield.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/categorie_section.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/date_transaction_card.dart';
import 'package:suivi_budget/Core/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/Core/widgets/custom_textfield_widget.dart';

class AjouterDepenseView extends StatefulWidget {
  const AjouterDepenseView({super.key});

  @override
  State<AjouterDepenseView> createState() => _AjouterDepenseViewState();
}

class _AjouterDepenseViewState extends State<AjouterDepenseView> {
  //Les controlleurs des champs des textes
  TextEditingController montantText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
  // Date de la transaction
  DateTime date = DateTime.now();
  // La categorie de revenu
  String categorie = "";

  @override
  void dispose() {
    montantText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // le solde du compte
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          CustomMontantTextfield(montantController: montantText),
          const Gap(16),

          CategorieSection(
            typeCategorie: "Depense",
            choixVal: (val) => setState(() {
              categorie = val!;
            }),
          ),
          const Gap(16),

          CustomTextfieldWidget(
            icone: Icons.text_fields_sharp,
            label: "Ajouter une description",
            typeInput: TextInputType.text,
            controlleurChamp: descriptionText,
          ),
          const Gap(16),

          DateTransactionCard(
            changementDate: (dateChoisie) => date = dateChoisie,
          ),
          const Gap(16),
          Consumer<DatabaseProvider>(
            builder: (context, database, child) => CustomFilledButtonWidget(
              texte: "Enregistrer transaction",
              action: () async {
                final checkBalance = balanceAvailable(
                  database.soldeTotal(),
                  int.parse(montantText.text),
                  context,
                );
                if (!checkBalance) {
                  return;
                }
                await database.addTransaction(
                  context,
                  transaction: Transaction(
                    montant: int.parse(montantText.text.trim()),
                    category: categorie,
                    description: descriptionText.text.trim(),
                    type: "Depense",
                    date: date.toString(),
                  ),
                );
                montantText.clear();
                descriptionText.clear();
              },
              chargement: false,
            ),
          ),
        ],
      ),
    );
  }
}
