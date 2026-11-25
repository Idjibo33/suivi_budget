import 'package:suivi_budget/views/transactions/confirmer_depense.dart';
import 'package:suivi_budget/views/budgets/widgets/creer_budget_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/etats/validation_transaction.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/transactions/budget_section.dart';
import 'package:suivi_budget/views/transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/transactions/depenses/categorie_section.dart';
import 'package:suivi_budget/views/transactions/montants_suggeres_widget.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

/// Formulaire partagé par la création d'un revenu et d'une dépense.
///
/// La catégorie et l'enveloppe viennent de la base : le type de la transaction
/// est déduit de la catégorie, jamais saisi séparément.
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
  Categorie? _categorie;
  Budget? _budget;
  DateTime date = DateTime.now();

  bool get estRevenu => widget.type == 'Revenu';

  @override
  void dispose() {
    montantText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  Future<void> enregistrer(
    DatabaseProvider database, {
    required Categorie categorie,
    required Budget? budget,
  }) async {
    final resultat = validerMontant(montantText.text);
    if (resultat is! MontantValide) {
      showErrorSnackbar(context, (resultat as MontantInvalide).message);
      return;
    }

    if (!estRevenu && !await confirmerDepense(
      context, database, budget: budget, montant: resultat.montant, date: date,
    )) return;
    if (!mounted) return;

    final bool reussi = await database.addTransaction(
      context,
      transaction: Transaction(
        montant: resultat.montant,
        category: categorie.nom,
        categorieId: categorie.id ?? 0,
        budgetId: budget?.id,
        description: descriptionText.text.trim(),
        type: categorie.type,
        date: date.toString(),
      ),
    );
    if (reussi && mounted) {
      montantText.clear();
      descriptionText.clear();
    }
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double largeur = constraints.maxWidth < 720
            ? constraints.maxWidth
            : 720.0;
        return Center(
          child: SizedBox(
            width: largeur,
            child: Consumer<DatabaseProvider>(
              builder: (context, database, child) {
                final List<Categorie> categories = estRevenu
                    ? database.categoriesRevenu
                    : database.categoriesDepense;
                final Categorie? categorie =
                    _categorie != null &&
                        categories.any((item) => item.id == _categorie!.id)
                    ? _categorie
                    : categories.firstOrNull;
                final Budget? budget =
                    _budget != null &&
                        database.budgets.any((item) => item.id == _budget!.id)
                    ? _budget
                    : database.budgets.firstOrNull;

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
                      categories: categories,
                      categorieChoisieId: categorie?.id,
                      choixVal: (choix) => setState(() => _categorie = choix),
                    ),
                    const Gap(24),
                    if (!estRevenu) ...[
                      libelle('BUDGET'),
                      const Gap(8),
                      BudgetSection(
                        budgets: database.budgets,
                        budgetChoisiId: budget?.id,
                        choixVal: (choix) => setState(() => _budget = choix),
                      ),
                      const Gap(24),
                      if (database.budgets.isEmpty)
                        TextButton(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (_) => const CreerBudgetDialog(),
                          ),
                          child: const Text('Créer un budget'),
                        ),
                    ],
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
                    if (estRevenu || budget != null)
                      CustomFilledButtonWidget(
                        texte: "Enregistrer transaction",
                        action: () async {
                          if (categorie == null ||
                              (!estRevenu && budget == null)) {
                            showErrorSnackbar(
                              context,
                              'Une catégorie et un budget sont nécessaires',
                            );
                            return;
                          }
                          await enregistrer(
                            database,
                            categorie: categorie,
                            budget: estRevenu ? null : budget,
                          );
                        },
                        chargement: database.chargement,
                      ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
