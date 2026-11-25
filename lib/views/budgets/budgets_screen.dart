import 'package:suivi_budget/views/budgets/widgets/modeles_budget.dart';
import 'package:suivi_budget/models/modele_budget.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';
import 'package:suivi_budget/views/budgets/widgets/augmenter_plafond.dart';
import 'package:suivi_budget/models/etats/vue_budgets.dart';
import 'package:suivi_budget/views/budgets/rapports_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/etats/etat_filtre_budget.dart';
import 'package:suivi_budget/models/etats/etat_vue_budget.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/models/etats/onglet_analyse.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/helpers/icone_type_transaction.dart';
import 'package:suivi_budget/models/helpers/repartition.dart';
import 'package:suivi_budget/models/helpers/responsive.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/widgets/budget_card.dart';
import 'package:suivi_budget/views/budgets/widgets/carte_budget_vide.dart';
import 'package:suivi_budget/views/budgets/widgets/creer_budget_dialog.dart';
import 'package:suivi_budget/views/budgets/widgets/empty_state_card.dart';
import 'package:suivi_budget/views/budgets/widgets/empty_state_editor.dart';
import 'package:suivi_budget/views/budgets/widgets/panel_categories.dart';
import 'package:suivi_budget/views/budgets/widgets/repartition_categories.dart';
import 'package:suivi_budget/views/budgets/widgets/jauge_budget.dart';

/// Écran Budgets/Analyses de la V2, inspiré de la variante D validée :
/// enveloppes épinglées à gauche sur grand écran, sections empilées sur mobile.
class BudgetsScreen extends StatefulWidget {
  const BudgetsScreen({super.key, this.budgetInitialId});

  final int? budgetInitialId;

  @override
  State<BudgetsScreen> createState() => _BudgetsScreenState();
}

class _BudgetsScreenState extends State<BudgetsScreen> {
  VueBudgets _section = VueBudgets.mesBudgets;
  EtatFiltreBudget _filtre = EtatFiltreBudget.enCours;
  EtatVueBudget _vue = EtatVueBudget.donnees;
  OngletAnalyse _onglet = OngletAnalyse.enveloppes;
  late int? _selectionId = widget.budgetInitialId;

  void changerFiltre(EtatFiltreBudget filtre) =>
      setState(() => _filtre = filtre);

  void changerOnglet(OngletAnalyse onglet) => setState(() => _onglet = onglet);

  Future<void> archiverBudget(Budget budget) =>
      context.read<DatabaseProvider>().archiverBudget(context, budget: budget);

  Future<void> desarchiverBudget(Budget budget) => context
      .read<DatabaseProvider>()
      .desarchiverBudget(context, budget: budget);

  void ouvrirCreationBudget() {
    ouvrirCreationBudgetAvecModeles(context);
  }

  /// L'éditeur reste le même widget ; il est présenté dans un bottom sheet
  /// pour rester accessible sans encombrer la page d'analyses.
  void ouvrirEditeurEtatVide() => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.9,
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: EmptyStateEditor(),
      ),
    ),
  );

  void ouvrirAjoutTransaction() => naviguerAjouterTransactionPage(context);

  /// Le bouton du modèle d'état vide exécute l'action annoncée par son preset.
  void executerActionEtatVide(PresetEtatVide preset) => switch (preset) {
    PresetEtatVide.guide => ouvrirCreationBudget(),
    PresetEtatVide.encourageant => ouvrirAjoutTransaction(),
    PresetEtatVide.minimal => ouvrirCreationBudget(),
  };

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) {
        final bool archives = switch (_filtre) {
          EtatFiltreBudget.enCours => false,
          EtatFiltreBudget.archives => true,
        };
        final List<Budget> budgets = database.budgetsSelon(
          (budget) => budget.archive == archives,
        );
        final Budget? budget =
            budgets.where((item) => item.id == _selectionId).firstOrNull ??
            budgets.firstOrNull;
        final List<Transaction> transactions =
            budget == null || budget.id == null
            ? database.transactionsListe
            : database.transactionsListe
                  .where((item) => item.budgetId == budget.id)
                  .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Budgets & analyses'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: SegmentedButton<VueBudgets>(
                segments: const [
                  ButtonSegment(
                    value: VueBudgets.mesBudgets,
                    label: Text('Mes budgets'),
                  ),
                  ButtonSegment(
                    value: VueBudgets.rapports,
                    label: Text('Rapports'),
                  ),
                ],
                selected: {_section},
                onSelectionChanged: (choix) =>
                    setState(() => _section = choix.single),
              ),
            ),
            actions: [
              if (_section == VueBudgets.mesBudgets)
                Tooltip(
                  message: 'Personnaliser l’état vide',
                  child: TextButton.icon(
                    onPressed: ouvrirEditeurEtatVide,
                    icon: const Icon(Icons.tune_outlined, size: 18),
                    label: const Text('Personnaliser'),
                  ),
                ),
            ],
          ),
          floatingActionButton: _section == VueBudgets.rapports
              ? null
              : FloatingActionButton(
                  onPressed: ouvrirCreationBudget,
                  tooltip: 'Nouveau budget',
                  child: const Icon(Icons.add),
                ),
          body: switch (_section) {
            VueBudgets.rapports => const RapportsView(),
            VueBudgets.mesBudgets => LayoutBuilder(
              builder: (context, constraints) {
                final Widget contenuHero = _Hero(
                  database: database,
                  budget: budget,
                  vue: _vue,
                );
                final Widget contenuBudgets = _Budgets(
                  budgets: budgets,
                  budget: budget,
                  database: database,
                  filtre: _filtre,
                  vue: _vue,
                  changerFiltre: changerFiltre,
                  changerVue: () => setState(() => _vue = _vue.basculer()),
                  selectionner: (choix) =>
                      setState(() => _selectionId = choix.id),
                  creer: ouvrirCreationBudget,
                  archiver: archiverBudget,
                  desarchiver: desarchiverBudget,
                  personnaliser: ouvrirEditeurEtatVide,
                  actionEtatVide: () =>
                      executerActionEtatVide(database.modeleEtatVide.preset),
                );
                final List<LigneRepartition> lignes = repartitionParCategorie(
                  transactions: transactions,
                  categories: database.categories,
                );
                final List<Transaction> recents = transactions.take(3).toList();
                final String titreRepartition = budget == null
                    ? 'Répartition globale'
                    : 'Répartition · ${budget.nom}';
                final bool archivesVides = archives && budgets.isEmpty;
                final Widget contenuCharts = _Charts(
                  lignes: lignes,
                  recents: recents,
                  titre: titreRepartition,
                  archivesVides: archivesVides,
                );
                final Widget contenuPersonnalisation = _Personnalisation(
                  database: database,
                  personnaliser: ouvrirEditeurEtatVide,
                );

                if (constraints.maxWidth < Responsive.mobileMax) {
                  final Widget contenuOnglet = _contenuOnglet(
                    _onglet,
                    budgets: contenuBudgets,
                    repartition: archivesVides
                        ? const _AnalysesArchivesVides()
                        : _Repartition(titre: titreRepartition, lignes: lignes),
                    transactions: archivesVides
                        ? const _AnalysesArchivesVides()
                        : _Transactions(transactions: recents),
                    personnalisation: contenuPersonnalisation,
                  );
                  return SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 96),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        contenuHero,
                        const Gap(16),
                        _OngletsBudget(
                          actif: _onglet,
                          selectionner: changerOnglet,
                        ),
                        const Gap(16),
                        contenuOnglet,
                      ],
                    ),
                  );
                }

                if (constraints.maxWidth < Responsive.tableauMax) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 220,
                          child: SingleChildScrollView(child: contenuBudgets),
                        ),
                        const Gap(12),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                contenuHero,
                                const Gap(16),
                                contenuCharts,
                                const Gap(16),
                                contenuPersonnalisation,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 280,
                        child: SingleChildScrollView(child: contenuBudgets),
                      ),
                      const Gap(20),
                      Expanded(
                        flex: 3,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              contenuHero,
                              const Gap(16),
                              contenuCharts,
                            ],
                          ),
                        ),
                      ),
                      const Gap(20),
                      SizedBox(
                        width: 260,
                        child: SingleChildScrollView(
                          child: contenuPersonnalisation,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          },
        );
      },
    );
  }
}

/// Sélection exhaustive d'un seul contenu mobile : la page ne stack plus
/// toutes les sections à la fois.
Widget _contenuOnglet(
  OngletAnalyse onglet, {
  required Widget budgets,
  required Widget repartition,
  required Widget transactions,
  required Widget personnalisation,
}) => switch (onglet) {
  OngletAnalyse.enveloppes => budgets,
  OngletAnalyse.repartition => repartition,
  OngletAnalyse.transactions => transactions,
  OngletAnalyse.personnalisation => personnalisation,
};

class _OngletsBudget extends StatelessWidget {
  const _OngletsBudget({required this.actif, required this.selectionner});

  final OngletAnalyse actif;
  final ValueChanged<OngletAnalyse> selectionner;

  @override
  Widget build(BuildContext context) {
    final couleurs = Theme.of(context).colorScheme;
    final onglets = OngletAnalyse.values;
    Widget bouton(OngletAnalyse onglet) {
      final selectionne = actif == onglet;
      final couleur = selectionne ? couleurs.primary : couleurs.onSurface;
      return Semantics(
        selected: selectionne,
        child: OutlinedButton(
          onPressed: () => selectionner(onglet),
          style: OutlinedButton.styleFrom(
            foregroundColor: couleur,
            backgroundColor: selectionne ? couleurs.primaryContainer : null,
            side: BorderSide(
              color: selectionne ? couleurs.primary : couleurs.outlineVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: const Size(0, 48),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            textStyle: TextStyle(
              fontSize: 13,
              fontWeight: selectionne ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 4,
            children: [
              Icon(onglet.icone, size: 16),
              Text(onglet.libelle, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    Widget rangee(int debut) => Row(
      children: [
        Expanded(child: bouton(onglets[debut])),
        const Gap(8),
        Expanded(child: bouton(onglets[debut + 1])),
      ],
    );

    return Column(children: [rangee(0), const Gap(8), rangee(2)]);
  }
}

class _Hero extends StatelessWidget {
  final DatabaseProvider database;
  final Budget? budget;
  final EtatVueBudget vue;

  const _Hero({
    required this.database,
    required this.budget,
    required this.vue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SOLDE GLOBAL',
          style: Styles.texteCorps.copyWith(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.6,
            color: Styles.texteSecondaire(context),
          ),
        ),
        const Gap(4),
        Text(
          FormatMontant.afficherAvecDevise(database.soldeTotal()),
          style: Styles.texteMontant,
        ),
        if (switch (vue) {
          EtatVueBudget.donnees => budget != null,
          EtatVueBudget.vide => false,
        }) ...[
          const Gap(16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Styles.surfaceSecondaire(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reste à dépenser · ${budget!.nom}',
                  style: Styles.texteCorps.copyWith(
                    fontSize: 11,
                    color: Styles.texteSecondaire(context),
                  ),
                ),
                const Gap(4),
                Text(
                  FormatMontant.afficherAvecDevise(
                    database.totauxDuBudget(budget!).disponible,
                  ),
                  style: Styles.texteMontantCompact,
                ),
                const Gap(8),
                JaugeBudget(totaux: database.totauxDuBudget(budget!)),
                if (!budget!.archive)
                  PopupMenuButton<bool>(
                    tooltip: 'Règle de dépassement',
                    onSelected: (autorise) =>
                        database.changerAutorisationDepassement(
                          context,
                          budget!,
                          autorise,
                        ),
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: false,
                        child: Text('Bloquer le dépassement'),
                      ),
                      PopupMenuItem(
                        value: true,
                        child: Text('Autoriser avec avertissement'),
                      ),
                    ],
                    child: Text(
                      budget!.depassementAutorise
                          ? 'Dépassement autorisé · Modifier'
                          : 'Dépassement bloqué · Modifier',
                    ),
                  ),
                if (!budget!.archive)
                  TextButton(
                    onPressed: () => proposerHaussePlafond(
                      context,
                      database,
                      budget!,
                      DateTime.now(),
                    ),
                    child: const Text('Augmenter le plafond'),
                  ),
                TextButton(
                  onPressed: () => showDialog<void>(
                    context: context,
                    builder: (_) => CreerBudgetDialog(
                      modele: ModeleBudget(
                        nom: budget!.nom,
                        plafond: budget!.alloue,
                        periodeLibre: budget!.periodeValide is PeriodeLibre,
                        depassementAutorise: budget!.depassementAutorise,
                      ),
                      enregistrerModele: (dialogue, modele) =>
                          database.enregistrerModelesBudget(dialogue, [
                            ...database.modelesBudget,
                            modele,
                          ]),
                    ),
                  ),
                  child: const Text('Enregistrer comme modèle'),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Budgets extends StatelessWidget {
  final List<Budget> budgets;
  final Budget? budget;
  final DatabaseProvider database;
  final EtatFiltreBudget filtre;
  final EtatVueBudget vue;
  final void Function(EtatFiltreBudget) changerFiltre;
  final VoidCallback changerVue;
  final void Function(Budget) selectionner;
  final VoidCallback creer;
  final Future<void> Function(Budget) archiver;
  final Future<void> Function(Budget) desarchiver;
  final VoidCallback personnaliser;
  final VoidCallback actionEtatVide;

  const _Budgets({
    required this.budgets,
    required this.budget,
    required this.database,
    required this.filtre,
    required this.vue,
    required this.changerFiltre,
    required this.changerVue,
    required this.selectionner,
    required this.creer,
    required this.archiver,
    required this.desarchiver,
    required this.personnaliser,
    required this.actionEtatVide,
  });

  @override
  Widget build(BuildContext context) {
    final Widget contenuEtatVide = switch (filtre) {
      EtatFiltreBudget.enCours => CarteBudgetVide(
        modele: database.modeleEtatVide,
        onAction: actionEtatVide,
        onPersonnaliser: personnaliser,
      ),
      EtatFiltreBudget.archives => EmptyStateCard(
        modele: ModeleEtatVide.archivesVides,
        onAction: () => changerFiltre(EtatFiltreBudget.enCours),
      ),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(switch (filtre) {
                EtatFiltreBudget.enCours => 'Budgets en cours',
                EtatFiltreBudget.archives => 'Budgets archivés',
              }, style: Styles.texteTitre),
            ),
            TextButton(onPressed: changerVue, child: Text(vue.libelle)),
          ],
        ),
        const Gap(6),
        SegmentedButton<EtatFiltreBudget>(
          segments: [
            for (final value in EtatFiltreBudget.values)
              ButtonSegment(value: value, label: Text(value.libelle)),
          ],
          selected: {filtre},
          onSelectionChanged: (selection) => changerFiltre(selection.first),
        ),
        const Gap(12),
        if (switch (vue) {
          EtatVueBudget.vide => true,
          EtatVueBudget.donnees => budgets.isEmpty,
        })
          contenuEtatVide
        else
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final enveloppe in budgets)
                BudgetCard(
                  budget: enveloppe,
                  totaux: database.totauxDuBudget(enveloppe),
                  selectionnee: enveloppe.id == budget?.id,
                  onTap: () => selectionner(enveloppe),
                  onArchive: enveloppe.archive
                      ? null
                      : () => archiver(enveloppe),
                  onDesarchiver: enveloppe.archive
                      ? () => desarchiver(enveloppe)
                      : null,
                ),
            ],
          ),
        if (filtre == EtatFiltreBudget.enCours &&
            vue == EtatVueBudget.donnees &&
            budgets.isEmpty) ...[
          const Gap(12),
          const ModelesBudget(),
        ],
        const Gap(12),
        OutlinedButton.icon(
          onPressed: creer,
          icon: const Icon(Icons.add),
          label: const Text('Nouveau budget'),
        ),
        if (switch (vue) {
          EtatVueBudget.vide => true,
          EtatVueBudget.donnees => false,
        })
          TextButton(
            onPressed: personnaliser,
            child: const Text('Personnaliser le modèle'),
          ),
      ],
    );
  }
}

class _Charts extends StatelessWidget {
  final List<LigneRepartition> lignes;
  final List<Transaction> recents;
  final String titre;
  final bool archivesVides;

  const _Charts({
    required this.lignes,
    required this.recents,
    required this.titre,
    this.archivesVides = false,
  });

  @override
  Widget build(BuildContext context) {
    if (archivesVides) {
      return const _AnalysesArchivesVides();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Repartition(titre: titre, lignes: lignes),
        const Gap(16),
        _Transactions(transactions: recents),
      ],
    );
  }
}

class _AnalysesArchivesVides extends StatelessWidget {
  const _AnalysesArchivesVides();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analyses', style: Styles.texteTitre),
        Gap(8),
        Text('Aucune donnée archivée.', style: Styles.texteCorps),
      ],
    );
  }
}

class _Repartition extends StatelessWidget {
  final String titre;
  final List<LigneRepartition> lignes;

  const _Repartition({required this.titre, required this.lignes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titre, style: Styles.texteTitre),
        const Gap(8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: RepartitionCategories(lignes: lignes),
          ),
        ),
      ],
    );
  }
}

class _Transactions extends StatelessWidget {
  final List<Transaction> transactions;

  const _Transactions({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Dernières transactions', style: Styles.texteTitre),
        const Gap(4),
        for (final transaction in transactions)
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              iconeTypeTransaction(transaction.typeCategorie),
              size: 18,
              color: transaction.estRevenu
                  ? Styles.couleurRevenu(context)
                  : Styles.couleurDepense(context),
            ),
            title: Text(transaction.description, style: Styles.texteCorps),
            subtitle: Text(transaction.category, style: Styles.texteCorps),
            trailing: Text(
              FormatMontant.afficherAvecSigne(
                transaction.montant,
                estRevenu: transaction.estRevenu,
              ),
              style: Styles.texteCorps.copyWith(
                fontWeight: FontWeight.w600,
                color: transaction.estRevenu
                    ? Styles.couleurRevenu(context)
                    : Styles.couleurDepense(context),
              ),
            ),
          ),
      ],
    );
  }
}

class _Personnalisation extends StatelessWidget {
  final DatabaseProvider database;
  final VoidCallback personnaliser;

  const _Personnalisation({
    required this.database,
    required this.personnaliser,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('État vide', style: Styles.texteTitre)),
            TextButton(onPressed: personnaliser, child: const Text('Modifier')),
          ],
        ),
        const Gap(8),
        EmptyStateCard(modele: database.modeleEtatVide),
        const Gap(20),
        const PanelCategories(),
      ],
    );
  }
}
