import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/validation_transaction.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/transactions/depenses/categorie_section.dart';
import 'package:suivi_budget/views/transactions/montants_suggeres_widget.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

/// Formulaire partagé par la création d'un revenu et d'une dépense.
///
/// L'état du formulaire appartient à ce widget ; les écrans `Revenu` et
/// `Depense` ne sont que des adaptateurs qui fixent le type de transaction.
class FormulaireTransactionWidget extends StatefulWidget {
  /// Valeur exacte attendue par la base : `"Revenu"` ou `"Depense"`.
  final String type;

  const FormulaireTransactionWidget({super.key, required this.type});

  @override
  State<FormulaireTransactionWidget> createState() =>
      _FormulaireTransactionWidgetState();
}

class _FormulaireTransactionWidgetState
    extends State<FormulaireTransactionWidget> {
  final TextEditingController montantText = TextEditingController();
  final TextEditingController descriptionText = TextEditingController();
  String categorie = "";
  DateTime date = DateTime.now();

  bool get estRevenu => widget.type == 'Revenu';

  @override
  void dispose() {
    montantText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  Future<void> enregistrer(DatabaseProvider database) async {
    final ResultatValidationMontant resultat = validerMontant(
      montantText.text,
      soldeDisponible: estRevenu ? null : database.soldeTotal(),
    );
    if (resultat is! MontantValide) {
      showErrorSnackbar(context, (resultat as MontantInvalide).message);
      return;
    }

    await database.addTransaction(
      context,
      transaction: Transaction(
        montant: resultat.montant,
        category: categorie,
        description: descriptionText.text.trim(),
        type: widget.type,
        date: date.toString(),
      ),
    );
    montantText.clear();
    descriptionText.clear();
  }

  Widget libelle(String texte) {
    return Text(
      texte,
      style: Styles.texteCorps.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: Styles.texteSecondaire(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) {
        return ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            libelle('MONTANT'),
            const Gap(8),
            CustomMontantTextfield(montantController: montantText),
            const Gap(12),
            libelle('MONTANTS FRÉQUENTS'),
            const Gap(8),
            MontantsSuggeresWidget(controleur: montantText),
            const Gap(24),
            libelle('CATÉGORIE'),
            const Gap(8),
            CategorieSection(
              categorieChoisie: categorie,
              typeCategorie: widget.type,
              choixVal: (val) => setState(() => categorie = val),
            ),
            const Gap(24),
            libelle('DESCRIPTION'),
            const Gap(8),
            CustomTextfieldWidget(
              icone: Icons.text_fields_outlined,
              label: "Ajouter une description",
              typeInput: TextInputType.text,
              controlleurChamp: descriptionText,
            ),
            const Gap(24),
            libelle('DATE'),
            const Gap(8),
            DateTransactionCard(
              date: date,
              changementDate: (dateChoisie) =>
                  setState(() => date = dateChoisie),
            ),
            const Gap(28),
            CustomFilledButtonWidget(
              texte: "Enregistrer transaction",
              action: () => enregistrer(database),
              chargement: database.chargement,
            ),
          ],
        );
      },
    );
  }
}
