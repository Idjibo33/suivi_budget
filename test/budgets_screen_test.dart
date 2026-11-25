import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/models/etats/onglet_analyse.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/budgets/widgets/budget_card.dart';
import 'package:suivi_budget/views/budgets/widgets/carte_budget_vide.dart';
import 'package:suivi_budget/views/budgets/widgets/empty_state_card.dart';

import 'fixtures/fakes.dart';

Future<void> pomperBudgets(
  WidgetTester tester, {
  required FakeTransactionDao dao,
  required DatabaseProvider provider,
  Size taille = const Size(1200, 900),
}) async {
  tester.view.physicalSize = taille;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => provider,
      child: const MaterialApp(home: BudgetsScreen()),
    ),
  );
  await tester.pump();
  await dao.emitCategories([
    Categorie(id: 1, nom: 'Courses', type: 'Depense', famille: 'Essentiel'),
  ]);
  await dao.emitBudgets([Budget(id: 1, nom: 'Maison', alloue: 100000)]);
  await dao.emit([
    buildTransaction(
      id: 1,
      montant: 5000,
      categorieId: 1,
      budgetId: 1,
      type: 'Depense',
      date: DateTime.now().toIso8601String(),
    ),
  ]);
  await tester.pump();
}

Future<void> pomperBudgetsVides(
  WidgetTester tester, {
  required FakeTransactionDao dao,
  required DatabaseProvider provider,
  Size taille = const Size(390, 844),
}) async {
  tester.view.physicalSize = taille;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => provider,
      child: const MaterialApp(home: BudgetsScreen()),
    ),
  );
  await tester.pump();
  await dao.emitCategories([]);
  await dao.emitBudgets([]);
  await dao.emit([]);
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('le rapport relie le total aux dépenses historiques filtrées', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    await pomperBudgets(tester, dao: dao, provider: provider);
    await dao.emitBudgets([
      Budget(id: 1, nom: 'Maison', alloue: 100000, archive: true),
    ]);
    final date = DateTime.now().toIso8601String();
    await dao.emit([
      buildTransaction(
        id: 1,
        montant: 5000,
        type: 'Depense',
        category: 'Courses',
        budgetId: 1,
        date: date,
      ),
      buildTransaction(
        id: 2,
        montant: 2000,
        type: 'Depense',
        category: 'Transport',
        budgetId: null,
        date: date,
      ),
      buildTransaction(
        id: 3,
        montant: 9000,
        type: 'Revenu',
        category: 'Salaire',
        budgetId: null,
        date: date,
      ),
    ]);
    await tester.tap(find.text('Rapports'));
    await tester.pumpAndSettle();
    expect(find.text('7\u202f000 F CFA'), findsOneWidget);
    await tester.tap(find.text('Transport'));
    await tester.pumpAndSettle();
    expect(find.text('Courses'), findsNothing);
    expect(find.text('Transport'), findsWidgets);
  });

  testWidgets('affiche les enveloppes, la répartition et les transactions', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(tester, dao: dao, provider: provider);

    expect(find.text('Budgets & analyses'), findsOneWidget);
    expect(find.text('Maison'), findsWidgets);
    expect(find.text('Répartition · Maison'), findsOneWidget);
    expect(find.text('Dernières transactions'), findsOneWidget);
  });

  testWidgets('le filtre archivés et l’aperçu vide changent d’état', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(tester, dao: dao, provider: provider);

    await tester.tap(find.text('Archivés'));
    await tester.pump();
    expect(find.text('Aucun budget archivé'), findsOneWidget);
    expect(find.text('Voir les budgets en cours'), findsOneWidget);
    expect(find.text('Aucune donnée archivée.'), findsOneWidget);
    expect(find.text('Répartition globale'), findsNothing);

    await tester.tap(find.text('Voir les budgets en cours'));
    await tester.pump();
    expect(find.text('Budgets en cours'), findsOneWidget);

    await tester.tap(find.text('Archivés'));
    await tester.pump();
    await tester.tap(find.text('En cours'));
    await tester.pump();
    await tester.tap(find.text('Données'));
    await tester.pump();
    expect(find.text('Aperçu vide'), findsWidgets);
  });

  testWidgets('crée un budget mensuel depuis le dialogue', (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(tester, dao: dao, provider: provider);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Créer un budget personnalisé'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Nouveau budget'),
      ),
      findsOneWidget,
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Nom du budget'),
      'Voyage',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Plafond de dépenses'),
      '50000',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Créer'));
    await tester.pump();
    await tester.pump();

    expect(dao.addedBudgets, hasLength(1));
    expect(dao.addedBudgets.single.nom, 'Voyage');
    expect(dao.addedBudgets.single.alloue, 50000);
    expect(dao.addedBudgets.single.typePeriode, 'mensuel');
  });

  testWidgets('archive une enveloppe depuis sa carte', (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(tester, dao: dao, provider: provider);

    expect(find.byType(BudgetCard), findsOneWidget);
    await tester.tap(find.byTooltip('Archiver').first);
    await tester.pump();
    await tester.pump();

    expect(dao.updatedBudgets, hasLength(1));
    expect(dao.updatedBudgets.single.nom, 'Maison');
    expect(dao.updatedBudgets.single.archive, isTrue);
    expect(
      dao.updatedBudgets.single.updatedAt,
      isNot(dao.updatedBudgets.single.createdAt),
    );
  });

  testWidgets('une enveloppe archivée reste visible sans bouton Archiver', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => provider,
        child: const MaterialApp(home: BudgetsScreen()),
      ),
    );
    await tester.pump();
    await dao.emitCategories([]);
    await dao.emitBudgets([
      Budget(id: 1, nom: 'Ancienne', alloue: 1000, archive: true),
    ]);
    await tester.pump();
    await tester.tap(find.text('Archivés'));
    await tester.pump();

    expect(find.text('Ancienne'), findsOneWidget);
    expect(find.byTooltip('Archiver'), findsNothing);
    expect(find.byTooltip('Désarchiver'), findsOneWidget);
  });

  testWidgets('désarchive une enveloppe depuis sa carte', (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => provider,
        child: const MaterialApp(home: BudgetsScreen()),
      ),
    );
    await tester.pump();
    await dao.emitCategories([]);
    await dao.emitBudgets([
      Budget(id: 4, nom: 'Ancienne', alloue: 1000, archive: true),
    ]);
    await tester.pump();
    await tester.tap(find.text('Archivés'));
    await tester.pump();

    await tester.tap(find.byTooltip('Désarchiver'));
    await tester.pump();
    await tester.pump();

    expect(dao.updatedBudgets, hasLength(1));
    expect(dao.updatedBudgets.single.nom, 'Ancienne');
    expect(dao.updatedBudgets.single.archive, isFalse);
    expect(
      dao.updatedBudgets.single.updatedAt,
      isNot(dao.updatedBudgets.single.createdAt),
    );
  });

  testWidgets('la tablette garde les enveloppes et les analyses visibles', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(
      tester,
      dao: dao,
      provider: provider,
      taille: const Size(800, 900),
    );

    expect(find.text('Budgets en cours'), findsOneWidget);
    expect(find.text('Répartition · Maison'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('le CTA du preset encourageant ouvre l’ajout de transaction', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(tester, dao: dao, provider: provider);
    final modele = provider.modeleEtatVide.appliquerPreset(
      PresetEtatVide.encourageant,
    );
    await provider.enregistrerModeleEtatVide(
      tester.element(find.byType(BudgetsScreen)),
      modele: modele,
    );
    await tester.tap(find.text('Données'));
    await tester.pump();

    expect(find.text('Ajouter une transaction'), findsWidgets);
    await tester.tap(find.text('Ajouter une transaction').first);
    await tester.pump();

    expect(find.text('Ajouter une transaction'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile : les onglets affichent un seul contenu à la fois', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(
      tester,
      dao: dao,
      provider: provider,
      taille: const Size(390, 844),
    );

    for (final onglet in OngletAnalyse.values) {
      final bouton = find.widgetWithText(OutlinedButton, onglet.libelle);
      expect(bouton.hitTestable(), findsOneWidget);
      expect(tester.getSize(bouton).height, greaterThanOrEqualTo(48));
    }

    expect(find.text('SOLDE GLOBAL'), findsOneWidget);
    for (final onglet in OngletAnalyse.values) {
      expect(find.text(onglet.libelle), findsOneWidget);
    }
    expect(find.text('Budgets en cours'), findsOneWidget);
    expect(find.text('Répartition · Maison'), findsNothing);
    expect(find.text('Dernières transactions'), findsNothing);

    await tester.tap(find.text('Répartition'));
    await tester.pump();
    expect(find.text('Répartition · Maison'), findsOneWidget);
    expect(find.text('Budgets en cours'), findsNothing);

    await tester.tap(find.text('Transactions'));
    await tester.pump();
    expect(find.text('Dernières transactions'), findsOneWidget);
    expect(find.text('Répartition · Maison'), findsNothing);

    await tester.tap(find.text('Personnalisation'));
    await tester.pump();
    expect(find.text('État vide'), findsOneWidget);
    expect(find.text('Catégories'), findsOneWidget);

    await tester.tap(find.text('Enveloppes'));
    await tester.pump();
    expect(find.text('Budgets en cours'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('la tablette ne bascule pas en onglets', (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(
      tester,
      dao: dao,
      provider: provider,
      taille: const Size(800, 900),
    );

    expect(find.byType(TabBar), findsNothing);
    expect(find.text('Enveloppes'), findsNothing);
    expect(find.text('Budgets en cours'), findsOneWidget);
    expect(find.text('Répartition · Maison'), findsOneWidget);
  });

  testWidgets('le bouton explicite ouvre l’éditeur dans un bottom sheet', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(tester, dao: dao, provider: provider);

    final Finder bouton = find.byTooltip('Personnaliser l’état vide');
    expect(bouton, findsOneWidget);
    expect(
      find.descendant(of: bouton, matching: find.text('Personnaliser')),
      findsOneWidget,
    );

    await tester.tap(bouton);
    await tester.pump();
    await tester.pump();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Personnaliser l’état vide'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile : le bouton ouvre l’éditeur en bottom sheet', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgets(
      tester,
      dao: dao,
      provider: provider,
      taille: const Size(390, 844),
    );

    await tester.tap(find.byTooltip('Personnaliser l’état vide'));
    await tester.pump();
    await tester.pump();

    expect(find.byType(BottomSheet), findsOneWidget);
    expect(find.text('Personnaliser l’état vide'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('sans budget actif, la carte enveloppe ouvre la création', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgetsVides(tester, dao: dao, provider: provider);

    final Finder carte = find.byType(CarteBudgetVide);
    expect(carte, findsOneWidget);
    expect(
      find.descendant(
        of: carte,
        matching: find.text(provider.modeleEtatVide.titre),
      ),
      findsOneWidget,
    );
    await tester.tap(
      find.descendant(
        of: carte,
        matching: find.text(provider.modeleEtatVide.titre),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Transport'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.widgetWithText(TextField, 'Nom du budget'))
          .controller!
          .text,
      'Transport',
    );
    expect(dao.addedBudgets, isEmpty);
  });

  testWidgets('le CTA de la carte enveloppe ouvre aussi la création', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgetsVides(tester, dao: dao, provider: provider);

    await tester.tap(
      find.descendant(
        of: find.byType(CarteBudgetVide),
        matching: find.widgetWithText(
          FilledButton,
          provider.modeleEtatVide.cta,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Transport'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.widgetWithText(TextField, 'Nom du budget'))
          .controller!
          .text,
      'Transport',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('l’onglet Archivés vide garde son état vide dédié', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    addTearDown(dao.close);

    await pomperBudgetsVides(tester, dao: dao, provider: provider);
    expect(find.byType(CarteBudgetVide), findsOneWidget);

    await tester.tap(find.text('Archivés'));
    await tester.pump();

    expect(find.byType(CarteBudgetVide), findsNothing);
    expect(find.byType(EmptyStateCard), findsOneWidget);
    expect(find.text('Aucun budget archivé'), findsOneWidget);
    expect(find.text('Voir les budgets en cours'), findsOneWidget);
  });
}
