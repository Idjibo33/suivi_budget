import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/transactions/depenses/ajouter_depense_view.dart';

import 'fixtures/fakes.dart';

class DaoAjoutEnEchec extends FakeTransactionDao {
  @override
  Future<void> addTransaction(Transaction transaction) async {
    throw Exception('échec ajout');
  }
}

Future<void> pumpDepense(WidgetTester tester, FakeTransactionDao dao) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)
            ..listenTransactions()
            ..listenDonneesV2(),
        ),
      ],
      child: const MaterialApp(home: Scaffold(body: AjouterDepenseView())),
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

  testWidgets('montant vide : aucun ajout et pas de crash', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 10000, type: 'Revenu')]);
    await tester.pump();

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(dao.added, isEmpty);
  });

  testWidgets('montant zéro : aucun ajout', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 10000, type: 'Revenu')]);
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, '0');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(dao.added, isEmpty);
  });

  testWidgets('montant valide : transaction ajoutée', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 10000, type: 'Revenu')]);
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, '5000');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump();

    expect(dao.added, hasLength(1));
    expect(dao.added.single.montant, 5000);
    expect(dao.added.single.type, 'Depense');

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('échec d’ajout : la saisie est conservée, aucun succès', (
    tester,
  ) async {
    final DaoAjoutEnEchec dao = DaoAjoutEnEchec();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 10000, type: 'Revenu')]);
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, '5000');
    await tester.enterText(find.byType(TextField).at(1), 'Café');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump();

    expect(dao.added, isEmpty);
    expect(
      tester.widget<TextField>(find.byType(TextField).first).controller!.text,
      '5000',
    );
    expect(
      tester.widget<TextField>(find.byType(TextField).at(1)).controller!.text,
      'Café',
    );
    expect(find.textContaining('ajoutée avec succès'), findsNothing);
    expect(find.textContaining('échec ajout'), findsOneWidget);
  });

  testWidgets('un montant suggéré remplit le champ et est enregistré', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 50000, type: 'Revenu')]);
    await tester.pump();

    await tester.tap(find.text(FormatMontant.afficher(10000)));
    await tester.pump();

    final TextField champ = tester.widget<TextField>(
      find.byType(TextField).first,
    );
    expect(champ.controller?.text, FormatMontant.pourSaisie(10000));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump();

    expect(dao.added, hasLength(1));
    expect(dao.added.single.montant, 10000);

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('solde insuffisant : aucun ajout', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emitBudgets([Budget(id: 1, nom: 'Général', alloue: 0)]);
    await dao.emit([buildTransaction(montant: 1000, type: 'Revenu')]);
    await tester.pump();

    await tester.enterText(find.byType(TextField).first, '2000');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(dao.added, isEmpty);
  });

  testWidgets(
    'un solde insuffisant demande confirmation sans bloquer la dépense',
    (tester) async {
      final FakeTransactionDao dao = FakeTransactionDao();
      addTearDown(dao.close);

      await pumpDepense(tester, dao);
      await dao.emitBudgets([Budget(id: 1, nom: 'Général', alloue: 5000)]);
      await dao.emit([buildTransaction(montant: 1000, type: 'Revenu')]);
      await tester.pump();

      await tester.enterText(find.byType(TextField).first, '2000');
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      await tester.pump();

      expect(dao.added, isEmpty);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enregistrer quand même'));
      await tester.pump();
      await tester.pump();
      expect(dao.added, hasLength(1));
      expect(dao.added.single.montant, 2000);

      await tester.pump(const Duration(seconds: 4));
    },
  );

  testWidgets('catégorie choisie : enregistrée avec la transaction', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 10000, type: 'Revenu')]);
    await tester.pump();

    await tester.tap(find.text('Courses'));
    await tester.enterText(find.byType(TextField).first, '5000');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    await tester.pump();

    expect(dao.added, hasLength(1));
    expect(dao.added.single.category, 'Courses');

    await tester.pump(const Duration(seconds: 4));
  });
}
