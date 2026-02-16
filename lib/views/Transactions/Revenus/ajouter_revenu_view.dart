import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Functions/creer_transaction.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_service_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_provider.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/Transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/Transactions/Revenus/revenus_categorie_section.dart';
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
  // Date de la transaction
  DateTime date = DateTime.now();

  @override
  void dispose() {
    montantText;
    descriptionText;
    date;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // l'id de l'utilisateur actuel
    final String idUtilisateur = AuthServices().currentUser!.uid;
    // La categorie de revenu
    String? categorie = context.watch<RevenusCategoriesProvider>().categorie;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            CustomMontantTextfield(montantController: montantText),
            const Gap(12),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text("Catégorie", style: Styles.texteTitre),
            ),
            const Gap(8),
            const RevenusCategorieSection(),
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
            Consumer<DocTransactionServiceProvider>(
              builder: (context, value, child) => CustomFilledButtonWidget(
                texte: "Enregistrer transaction",
                action: () {
                  creerTransaction(
                    context: context,
                    transaction: TransactionModel(
                      userId: idUtilisateur,
                      montant: int.parse(montantText.text.trim()),
                      category: categorie ?? "Aucune catégorie choisie",
                      description: descriptionText.text,
                      type: "Revenu",
                      date: date,
                    ),
                  );
                  montantText.clear();
                  descriptionText.clear();
                },
                chargement: value.chargement,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
