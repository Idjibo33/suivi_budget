import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/categorie_section.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/custom_montant_textfield.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/date_transaction_card.dart';
import 'package:suivi_budget/Core/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/Core/widgets/custom_textfield_widget.dart';

class AjouterRevenuScreen extends StatefulWidget {
  const AjouterRevenuScreen({super.key});

  @override
  State<AjouterRevenuScreen> createState() => _AjouterRevenuScreenState();
}

class _AjouterRevenuScreenState extends State<AjouterRevenuScreen> {
  final montantText = TextEditingController();
  final descriptionText = TextEditingController();
  // La categorie de revenu
  String? categorie = "";
  // Date de la transaction
  DateTime date = DateTime.now();

  @override
  void dispose() {
    montantText.dispose();
    descriptionText.dispose();
    date;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          CustomMontantTextfield(montantController: montantText),
          const Gap(16),

          CategorieSection(
            typeCategorie: "Revenu",
            choixVal: (val) => setState(() {
              categorie = val;
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
            changementDate: (datechoisie) => date = datechoisie,
          ),
          const Gap(16),
          Consumer<DatabaseProvider>(
            builder: (context, database, child) => CustomFilledButtonWidget(
              texte: "Enregistrer transaction",
              action: () async {
                await database.addTransaction(
                  context,
                  transaction: Transaction(
                    montant: int.parse(montantText.text.trim()),
                    category: categorie!,
                    description: descriptionText.text.trim(),
                    type: "Revenu",
                    date: date.toString(),
                  ),
                );
                montantText.clear();
                descriptionText.clear();
              },
              chargement: database.chargement,
            ),
          ),
        ],
      ),
    );
  }
}
