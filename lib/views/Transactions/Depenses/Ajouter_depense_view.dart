import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Transactions/Custom_montant_TextField.dart';
import 'package:suivi_budget/views/Transactions/Depenses/categorie_section.dart';
import 'package:suivi_budget/views/Transactions/Revenus/revenus_categorie_section.dart'
    hide CategorieSection;
import 'package:suivi_budget/views/Transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

class AjouterDepenseView extends StatelessWidget {
  const AjouterDepenseView({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController montantText = TextEditingController();
    TextEditingController descriptionText = TextEditingController();

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
            const DateTransactionCard(),
            const Gap(12),
            CustomFilledButtonWidget(
              texte: "Enregistrer transaction",
              action: () {},
              chargement: false,
            ),
          ],
        ),
      ),
    );
  }
}
