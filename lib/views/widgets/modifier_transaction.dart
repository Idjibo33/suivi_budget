import 'package:suivi_budget/views/transactions/confirmer_depense.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/etats/selection_modification_transaction.dart';
import 'package:suivi_budget/models/etats/type_categorie.dart';
import 'package:suivi_budget/models/etats/validation_transaction.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/views/transactions/budget_section.dart';
import 'package:suivi_budget/views/transactions/custom_montant_textfield.dart';
import 'package:suivi_budget/views/transactions/date_transaction_card.dart';
import 'package:suivi_budget/views/transactions/depenses/categorie_section.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';

/// Formulaire de modification : la catégorie choix est la seule source du
/// type, affiché en lecture seule, et l'enveloppe reste cohérente avec elle.
class ModifierTransaction extends StatefulWidget {
  final Transaction transaction;
  const ModifierTransaction({super.key, required this.transaction});

  @override
  State<ModifierTransaction> createState() => _ModifierTransactionState();
}

class _ModifierTransactionState extends State<ModifierTransaction> {
  final TextEditingController montantText = TextEditingController();
  final TextEditingController descriptionText = TextEditingController();

  SelectionModificationTransaction _selection =
      const SelectionModificationInitiale();

  late DateTime date =
      DateTime.tryParse(widget.transaction.date) ?? DateTime.now();

  @override
  void initState() {
    super.initState();
    montantText.text = FormatMontant.pourSaisie(widget.transaction.montant);
    descriptionText.text = widget.transaction.description;
  }

  @override
  void dispose() {
    montantText.dispose();
    descriptionText.dispose();
    super.dispose();
  }

  /// La sélection d'origine est conservée tant qu'elle est encore disponible ;
  /// sinon on retombe sur le premier choix actif plutôt que d'écrire un identifiant
  /// devenu invalide.
  Categorie? _categorieEfficace(List<Categorie> categories) {
    final Categorie? choisie = _selection.categorie;
    if (choisie != null && categories.any((item) => item.id == choisie.id)) {
      return choisie;
    }
    return categories
            .where((item) => item.id == widget.transaction.categorieId)
            .firstOrNull ??
        categories.firstOrNull;
  }

  Budget? _budgetEfficace(List<Budget> budgets) {
    final Budget? choisi = _selection.budget;
    if (choisi != null && budgets.any((item) => item.id == choisi.id)) {
      return choisi;
    }
    return budgets
            .where((item) => item.id == widget.transaction.budgetId)
            .firstOrNull ??
        budgets.firstOrNull;
  }

  Widget _libelle(String texte) => Text(
    texte,
    style: Styles.texteCorps.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.4,
      color: Styles.texteSecondaire(context),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) {
        final List<Categorie> categories = database.categories
            .where((categorie) => !categorie.archive)
            .toList();
        final List<Budget> budgets = database.budgets;
        final Categorie? categorie = _categorieEfficace(categories);
        final Budget? budget = _budgetEfficace(budgets);
        final String libelleType = switch (categorie?.typeCategorie) {
          TypeCategorie.revenu => 'Revenu',
          TypeCategorie.depense => 'Dépense',
          null => 'Indéterminé',
        };

        return Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomMontantTextfield(montantController: montantText),
            CustomTextfieldWidget(
              label: "Description",
              typeInput: TextInputType.text,
              controlleurChamp: descriptionText,
              icone: Icons.text_fields_rounded,
            ),
            _libelle('CATÉGORIE'),
            CategorieSection(
              categories: categories,
              categorieChoisieId: categorie?.id,
              choixVal: (choix) =>
                  setState(() => _selection = _selection.avecCategorie(choix)),
            ),
            Row(
              children: [
                Icon(
                  Icons.lock_outlined,
                  size: 14,
                  color: Styles.texteSecondaire(context),
                ),
                const Gap(6),
                Text('Type : $libelleType', style: Styles.texteCorps),
              ],
            ),
            if (categorie?.typeCategorie == TypeCategorie.depense) ...[
              _libelle('BUDGET'),
              BudgetSection(
                budgets: budgets,
                budgetChoisiId: budget?.id,
                choixVal: (choix) =>
                    setState(() => _selection = _selection.avecBudget(choix)),
              ),
            ],
            _libelle('DATE'),
            DateTransactionCard(
              date: date,
              changementDate: (dateChoisie) =>
                  setState(() => date = dateChoisie),
            ),
            const Gap(8),
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
                        if (categorie == null ||
                            (categorie.typeCategorie == TypeCategorie.depense &&
                                budget == null &&
                                widget.transaction.budgetId != null)) {
                          showErrorSnackbar(
                            context,
                            'Une catégorie et un budget sont nécessaires',
                          );
                          return;
                        }
                        if (categorie.typeCategorie == TypeCategorie.depense &&
                            !await confirmerDepense(
                              context,
                              database,
                              budget: budget,
                              montant: resultat.montant,
                              date: date,
                              ancienne: widget.transaction,
                            ))
                          return;
                        if (!context.mounted) return;
                        final bool reussi = await database.updateTransaction(
                          context,
                          transaction: Transaction(
                            id: widget.transaction.id,
                            montant: resultat.montant,
                            category: categorie.nom,
                            categorieId: categorie.id ?? 0,
                            budgetId:
                                categorie.typeCategorie == TypeCategorie.revenu
                                ? null
                                : budget?.id,
                            description: descriptionText.text.trim(),
                            type: categorie.type,
                            date: date.toString(),
                            createdAt: widget.transaction.createdAt,
                            updatedAt: widget.transaction.updatedAt,
                          ),
                        );
                        if (reussi && context.mounted) {
                          view.afficherConsultation();
                        }
                      },
                      chargement: database.chargement,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
