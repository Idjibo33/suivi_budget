import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/views/widgets/modifier_transaction.dart';
import 'package:suivi_budget/views/widgets/transaction_details_view.dart';

import 'fixtures/fakes.dart';

class DaoModificationEnEchec extends FakeTransactionDao {
  @override
  Future<void> editTransaction(Transaction transaction) async {
    throw Exception('échec modification');
  }
}

class DaoSuppressionEnEchec extends FakeTransactionDao {
  @override
  Future<void> deleteTransaction(int id) async {
    throw Exception('échec suppression');
  }
}

Future<void> pumpModifier(
  WidgetTester tester,
  FakeTransactionDao dao,
  Transaction transaction,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ModifierTransactionViewProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)
            ..listenTransactions()
            ..listenDonneesV2(),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ModifierTransaction(transaction: transaction),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
  await emitDonneesV2ParDefaut(dao);
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('enregistre les modifications saisies', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final Transaction original = buildTransaction(
      id: 7,
      montant: 1000,
      description: 'Ancienne description',
      category: 'Courses',
      type: 'Depense',
      date: '2026-10-19 08:00:00.000',
    );

    await pumpModifier(tester, dao, original);

    await tester.enterText(find.byType(TextField).at(0), '2500');
    await tester.enterText(
      find.byType(TextField).at(1),
      'Nouvelle description',
    );
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(dao.updated, isEmpty);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer quand même'));
    await tester.pump();
    await tester.pump();

    expect(dao.updated, hasLength(1));
    final Transaction updated = dao.updated.single;
    expect(updated.id, 7);
    expect(updated.montant, 2500);
    expect(updated.description, 'Nouvelle description');
    expect(updated.category, 'Courses');
    expect(updated.categorieId, 1);
    expect(updated.type, 'Depense');
    expect(updated.budgetId, 1);
    expect(updated.date, '2026-10-19 08:00:00.000');

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('changer de catégorie met à jour le type et les identifiants', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final Transaction original = buildTransaction(
      id: 7,
      category: 'Courses',
      type: 'Depense',
    );

    await pumpModifier(tester, dao, original);
    expect(find.text('Type : Dépense'), findsOneWidget);

    await tester.tap(find.text('Salaire'));
    await tester.pump();

    expect(find.text('Type : Revenu'), findsOneWidget);
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(dao.updated, hasLength(1));
    expect(dao.updated.single.category, 'Salaire');
    expect(dao.updated.single.categorieId, 2);
    expect(dao.updated.single.type, 'Revenu');
    expect(dao.updated.single.budgetId, isNull);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('les catégories archivées ne sont pas proposées', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    await pumpModifier(
      tester,
      dao,
      buildTransaction(category: 'Courses', type: 'Depense'),
    );

    await dao.emitCategories([
      Categorie(id: 1, nom: 'Courses', type: 'Depense'),
      Categorie(id: 2, nom: 'Salaire', type: 'Revenu'),
      Categorie(id: 3, nom: 'Ancienne', type: 'Depense', archive: true),
    ]);
    await tester.pump();

    expect(find.text('Ancienne'), findsNothing);
    expect(find.text('Courses'), findsOneWidget);
    expect(find.text('Salaire'), findsOneWidget);
  });

  testWidgets(
    'une catégorie d’origine indisponible est remplacée par une active',
    (tester) async {
      final FakeTransactionDao dao = FakeTransactionDao();
      addTearDown(dao.close);
      final Transaction original = buildTransaction(
        id: 8,
        categorieId: 99,
        category: 'Supprimée',
        type: 'Depense',
      );

      await pumpModifier(tester, dao, original);
      await tester.tap(find.text('Enregistrer'));
      await tester.pump();
      await tester.pump();

      expect(dao.updated, hasLength(1));
      expect(dao.updated.single.categorieId, 1);
      expect(dao.updated.single.category, 'Courses');
      expect(dao.updated.single.type, 'Depense');

      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('échec de modification : saisie conservée, aucun succès', (
    tester,
  ) async {
    final DaoModificationEnEchec dao = DaoModificationEnEchec();
    addTearDown(dao.close);
    await pumpModifier(
      tester,
      dao,
      buildTransaction(category: 'Courses', type: 'Depense'),
    );

    await tester.enterText(find.byType(TextField).at(0), '2500');
    await tester.enterText(find.byType(TextField).at(1), 'Texte conservé');
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(dao.updated, isEmpty);
    expect(find.byType(ModifierTransaction), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField).at(0)).controller!.text,
      '2500',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'Texte conservé',
    );
    expect(find.textContaining('modifiée avec succès'), findsNothing);
  });

  testWidgets('échec de suppression : la fiche reste ouverte', (tester) async {
    final DaoSuppressionEnEchec dao = DaoSuppressionEnEchec();
    addTearDown(dao.close);
    final Transaction transaction = buildTransaction(id: 9);

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ModifierTransactionViewProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) =>
                DatabaseProvider(database: dao)..listenTransactions(),
          ),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => FilledButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        TransactionDetailsView(transaction: transaction),
                  ),
                ),
                child: const Text('Ouvrir la fiche'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Ouvrir la fiche'));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Supprimer'));
    await tester.pump();
    await tester.pump();

    expect(dao.deleted, isEmpty);
    expect(find.text('DÉTAIL'), findsOneWidget);
    expect(find.textContaining('supprimé avec succès'), findsNothing);
  });

  testWidgets('montant invalide : aucun enregistrement', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpModifier(tester, dao, buildTransaction(id: 7, montant: 1000));

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(dao.updated, isEmpty);
  });

  testWidgets('la carte de date affiche la date enregistrée', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpModifier(
      tester,
      dao,
      buildTransaction(date: '2026-10-19 08:00:00.000'),
    );

    expect(find.textContaining('19 octobre 2026'), findsOneWidget);
  });
}
