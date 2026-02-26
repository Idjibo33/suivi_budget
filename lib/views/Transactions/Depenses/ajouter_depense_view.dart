import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/solde_provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_provider.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/Transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/Transactions/Depenses/categorie_section.dart';
import 'package:suivi_budget/views/Transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

class AjouterDepenseView extends StatefulWidget {
  const AjouterDepenseView({super.key});

  @override
  State<AjouterDepenseView> createState() => _AjouterDepenseViewState();
}

class _AjouterDepenseViewState extends State<AjouterDepenseView> {
  //Les controlleurs des champs des textes
  TextEditingController montantText = TextEditingController();
  TextEditingController descriptionText = TextEditingController();
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
    // le solde du compte
    final int solde = context.watch<SoldeProvider>().soldeTotal();
    // l'id de l'utilisateur actuel
    final String idUtilisateur = Auth().currentUser!.uid;
    // La categorie de revenu
    String? categorie = context.watch<DepensesCategoriesProvider>().categorie;
    // Date de la transaction
    DateTime date = DateTime.now();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CustomMontantTextfield(montantController: montantText),
            const Gap(12),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text("Catégorie", style: Styles.texteTitre),
            ),
            const Gap(8),
            const CategorieSection(),
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
              changementDate: (dateChoisie) => date = dateChoisie,
            ),
            const Gap(12),
            Consumer<DocTransactionProvider>(
              builder: (context, value, child) => CustomFilledButtonWidget(
                texte: "Enregistrer transaction",
                action: () async {
                  await value.creerDocTransaction(
                    context: context,
                    solde: solde,
                    transaction: TransactionModel(
                      id: "",
                      userId: idUtilisateur,
                      montant: int.parse(montantText.text),
                      category: categorie ?? "Aucunte catégorie choisie",
                      description: descriptionText.text,
                      type: "Depense",
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
