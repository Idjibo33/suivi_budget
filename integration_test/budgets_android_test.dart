import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categories_par_defaut.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/services/database/transaction_database.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/transactions/depenses/ajouter_depense_view.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('modèle, plafond et détail de rapport sur SQLite Android', (
    tester,
  ) async {
    await initializeDateFormatting('fr_FR');
    final db = await $FloorTransactionDatabase
        .inMemoryDatabaseBuilder()
        .build();
    addTearDown(db.close);
    final dao = db.transactionDao;
    for (final categorie in categoriesParDefaut) {
      await dao.addCategorie(categorie);
    }
    final provider = DatabaseProvider(database: dao)
      ..listenTransactions()
      ..listenDonneesV2();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: provider),
          ChangeNotifierProvider(
            create: (_) => ModifierTransactionViewProvider(),
          ),
        ],
        child: const MaterialApp(home: BudgetsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Nouveau budget'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.text('Transport'),
      ),
    );
    await tester.pumpAndSettle();

    final nom = find.widgetWithText(TextField, 'Nom du budget');
    expect(tester.widget<TextField>(nom).controller!.text, 'Transport');
    final plafond = find.widgetWithText(TextField, 'Plafond de dépenses');
    expect(tester.widget<TextField>(plafond).controller!.text, isEmpty);
    await tester.enterText(plafond, '15000');
    await tester.ensureVisible(find.byType(SwitchListTile));
    await tester.tap(find.byType(SwitchListTile));
    await tester.tap(find.widgetWithText(FilledButton, 'Créer'));
    await tester.pumpAndSettle();

    final budget = (await dao.getBudgets().first).single;
    expect(budget.nom, 'Transport');
    expect(budget.alloue, 15000);
    expect(budget.depassementAutorise, isTrue);
    expect(provider.soldeTotal(), 0);

    final categorie = (await dao.getCategories().first).firstWhere(
      (item) => item.type == 'Depense',
    );
    await dao.addBudget(Budget(nom: 'Archives', alloue: 10000, archive: true));
    final archive = (await dao.getToutBudgets().first).singleWhere(
      (item) => item.archive,
    );
    final date = DateTime.now().toIso8601String();
    for (final (montant, id) in [
      (3000, budget.id),
      (2000, archive.id),
      (1000, null),
    ]) {
      await dao.addTransaction(
        Transaction(
          montant: montant,
          category: categorie.nom,
          categorieId: categorie.id!,
          budgetId: id,
          description: 'Donnée de test',
          type: 'Depense',
          date: date,
        ),
      );
    }
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rapports'));
    await tester.pumpAndSettle();
    expect(find.text('6\u202f000 F CFA'), findsWidgets);
    expect(find.text('Où va mon argent ?'), findsOneWidget);
    final voirDepenses = find.descendant(
      of: find.widgetWithText(ListTile, categorie.nom),
      matching: find.text('Voir les dépenses'),
    );
    await tester.ensureVisible(voirDepenses);
    await tester.tap(voirDepenses);
    await tester.pumpAndSettle();
    expect(find.text(categorie.nom), findsNWidgets(4));
  });

  for (final (nom, depassementAutorise, revenu, plafond, avertissement) in [
    (
      'solde insuffisant : annulation puis confirmation',
      false,
      1000,
      5000,
      'Cette dépense rendra votre solde global négatif.',
    ),
    (
      'dépassement autorisé : plafond inchangé après confirmation',
      true,
      5000,
      1000,
      'Cette dépense dépasse le plafond du budget.',
    ),
  ]) {
    testWidgets(nom, (tester) async {
      await initializeDateFormatting('fr_FR');
      final db = await $FloorTransactionDatabase
          .inMemoryDatabaseBuilder()
          .build();
      addTearDown(db.close);
      final dao = db.transactionDao;
      for (final categorie in categoriesParDefaut) {
        await dao.addCategorie(categorie);
      }
      await dao.addBudget(
        Budget(
          nom: 'Courses',
          alloue: plafond,
          depassementAutorise: depassementAutorise,
        ),
      );
      final budget = (await dao.getBudgets().first).single;
      final categorie = (await dao.getCategories().first).firstWhere(
        (item) => item.type == 'Revenu',
      );
      await dao.addTransaction(
        Transaction(
          montant: revenu,
          category: categorie.nom,
          categorieId: categorie.id!,
          description: 'Revenu de test',
          type: 'Revenu',
          date: DateTime.now().toIso8601String(),
        ),
      );
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)
            ..listenTransactions()
            ..listenDonneesV2(),
          child: const MaterialApp(home: Scaffold(body: AjouterDepenseView())),
        ),
      );
      await tester.pumpAndSettle();
      final formulaire = find.byType(AjouterDepenseView);
      final enregistrer = find.descendant(
        of: formulaire,
        matching: find.byType(FilledButton),
      );
      await tester.enterText(find.byType(TextField).first, '2000');
      await tester.ensureVisible(enregistrer);
      await tester.tap(enregistrer);
      await tester.pumpAndSettle();
      expect(find.text(avertissement), findsOneWidget);
      expect((await dao.getTransactions().first).single.estRevenu, isTrue);
      await tester.tap(find.widgetWithText(TextButton, 'Annuler'));
      await tester.pumpAndSettle();
      expect((await dao.getTransactions().first).single.estRevenu, isTrue);
      await tester.tap(enregistrer);
      await tester.pumpAndSettle();
      expect(find.text(avertissement), findsOneWidget);
      await tester.tap(find.text('Enregistrer quand même'));
      await tester.pumpAndSettle();

      final transactions = await dao.getTransactions().first;
      expect(transactions, hasLength(2));
      final depense = transactions.singleWhere((item) => item.estDepense);
      expect(depense.montant, 2000);
      expect(depense.budgetId, budget.id);
      final provider = tester.element(formulaire).read<DatabaseProvider>();
      expect(provider.soldeTotal(), revenu - 2000);
      final budgetEnregistre = (await dao.getBudgets().first).single;
      expect(budgetEnregistre.alloue, plafond);
      expect(
        provider.totauxDuBudget(budgetEnregistre).disponible,
        plafond - 2000,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
