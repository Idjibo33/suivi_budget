import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/solde_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/Transactions/Depenses/categorie_section.dart';
import 'package:suivi_budget/views/Transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/Transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

class AjouterRevenuView extends StatefulWidget {
  const AjouterRevenuView({super.key});

  @override
  State<AjouterRevenuView> createState() => _AjouterRevenuViewState();
}

class _AjouterRevenuViewState extends State<AjouterRevenuView> {
  TextEditingController montantText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
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
    final int solde = context.watch<SoldeProvider>().soldeTotal();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView(
        children: [
          CustomMontantTextfield(montantController: montantText),
          const Gap(12),
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Text("Catégorie", style: Styles.texteTitre),
          ),
          const Gap(8),
          CategorieSection(
            typeCategorie: "Revenu",
            choixVal: (val) => setState(() {
              categorie = val;
            }),
          ),
          const Gap(12),
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Text("Description", style: Styles.texteTitre),
          ),
          const Gap(8),
          CustomTextfieldWidget(
            icone: Icons.text_fields_sharp,
            label: "Ajouter une description",
            typeInput: TextInputType.text,
            controlleurChamp: descriptionText,
          ),
          const Gap(12),
          Align(
            alignment: AlignmentGeometry.topLeft,
            child: Text("Date", style: Styles.texteTitre),
          ),
          const Gap(8),
          DateTransactionCard(
            changementDate: (datechoisie) => date = datechoisie,
          ),
          const Gap(12),
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
