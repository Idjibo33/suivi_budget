import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/etats/filtre_transactions.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';
import 'package:suivi_budget/views/widgets/liste_transactions_sheet.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

import 'fixtures/fakes.dart';

Future<void> pumpAccueilAvecSheet(
  WidgetTester tester,
  FakeTransactionDao dao, {
  List<Transaction>? transactions,
}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
        ),
        ChangeNotifierProvider(
          create: (_) => ModifierTransactionViewProvider(),
        ),
      ],
      child: MaterialApp(home: AccueilScreen(localAuth: FakeLocalAuth())),
    ),
  );
  await tester.pump();
  await tester.pump();
  if (transactions != null) {
    // Le DAO factice diffuse sur un broadcast : on émet après l'abonnement.
    await dao.emit(transactions);
    await tester.pump();
  }
}

/// Les assertions sont limitées à la feuille : l'accueil reste monté derrière.
Finder dansLaFeuille(Finder finder) =>
    find.descendant(of: find.byType(ListeTransactionsSheet), matching: finder);

Future<void> ouvrirLaFeuille(WidgetTester tester) async {
  await tester.ensureVisible(find.text('Voir tout'));
  await tester.tap(find.text('Voir tout'));
  await tester.pump();
  // La feuille glisse depuis le bas : on attend la fin de l'animation sans
  // pumpAndSettle, qui bloquerait sur le CircularProgressIndicator.
  await tester.pump(const Duration(milliseconds: 500));
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets(
    'voir tout ouvre une feuille haute avec toutes les transactions',
    (tester) async {
      final FakeTransactionDao dao = FakeTransactionDao();
      addTearDown(dao.close);

      await pumpAccueilAvecSheet(
        tester,
        dao,
        transactions: [
          buildTransaction(id: 1, category: 'Salaire'),
          buildTransaction(id: 2, category: 'Café', type: 'Depense'),
        ],
      );
      await ouvrirLaFeuille(tester);

      expect(find.byType(ListeTransactionsSheet), findsOneWidget);
      expect(
        dansLaFeuille(find.text('Toutes les transactions')),
        findsOneWidget,
      );
      expect(dansLaFeuille(find.byType(TransactionCard)), findsNWidgets(2));
      expect(dansLaFeuille(find.byType(SafeArea)), findsOneWidget);
      expect(
        tester.getSize(find.byType(ListeTransactionsSheet)).height,
        closeTo(844 * 0.85, 10),
      );
    },
  );

  testWidgets('les filtres changent le titre et la liste affichée', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueilAvecSheet(
      tester,
      dao,
      transactions: [
        buildTransaction(id: 1, category: 'Salaire'),
        buildTransaction(id: 2, category: 'Café', type: 'Depense'),
      ],
    );
    await ouvrirLaFeuille(tester);

    await tester.tap(dansLaFeuille(find.widgetWithText(ChoiceChip, 'Revenus')));
    await tester.pump();

    expect(dansLaFeuille(find.text('Transactions · Revenus')), findsOneWidget);
    expect(dansLaFeuille(find.byType(TransactionCard)), findsOneWidget);
    expect(dansLaFeuille(find.text('Café')), findsNothing);

    await tester.tap(
      dansLaFeuille(find.widgetWithText(ChoiceChip, 'Dépenses')),
    );
    await tester.pump();

    expect(dansLaFeuille(find.text('Transactions · Dépenses')), findsOneWidget);
    expect(dansLaFeuille(find.byType(TransactionCard)), findsOneWidget);
    expect(dansLaFeuille(find.text('Salaire')), findsNothing);
  });

  testWidgets('le message vide est adapté au filtre actif', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueilAvecSheet(
      tester,
      dao,
      transactions: [buildTransaction(id: 1, category: 'Salaire')],
    );
    await ouvrirLaFeuille(tester);

    await tester.tap(
      dansLaFeuille(find.widgetWithText(ChoiceChip, 'Dépenses')),
    );
    await tester.pump();

    expect(dansLaFeuille(find.text('Aucune dépense trouvée')), findsOneWidget);
    expect(dansLaFeuille(find.byType(TransactionCard)), findsNothing);

    await tester.tap(dansLaFeuille(find.widgetWithText(ChoiceChip, 'Revenus')));
    await tester.pump();

    expect(dansLaFeuille(find.text('Aucun revenu trouvé')), findsNothing);
    expect(dansLaFeuille(find.byType(TransactionCard)), findsOneWidget);
  });

  testWidgets('la feuille vide sans filtre garde le message par défaut', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueilAvecSheet(
      tester,
      dao,
      transactions: const <Transaction>[],
    );
    await ouvrirLaFeuille(tester);

    expect(
      dansLaFeuille(find.text('Aucune transaction trouvée')),
      findsOneWidget,
    );
  });

  testWidgets('la feuille se rafraîchit quand le provider notifie', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueilAvecSheet(
      tester,
      dao,
      transactions: [buildTransaction(id: 1, category: 'Salaire')],
    );
    await ouvrirLaFeuille(tester);
    await tester.tap(dansLaFeuille(find.widgetWithText(ChoiceChip, 'Revenus')));
    await tester.pump();
    expect(dansLaFeuille(find.byType(TransactionCard)), findsOneWidget);

    await dao.emit([
      buildTransaction(id: 1, category: 'Salaire'),
      buildTransaction(id: 2, category: 'Loyer', montant: 2000),
      buildTransaction(id: 3, category: 'Café', type: 'Depense'),
    ]);
    await tester.pump();

    expect(dansLaFeuille(find.byType(TransactionCard)), findsNWidgets(2));
    expect(dansLaFeuille(find.text('Transactions · Revenus')), findsOneWidget);

    await tester.tap(dansLaFeuille(find.widgetWithText(ChoiceChip, 'Toutes')));
    await tester.pump();
    expect(dansLaFeuille(find.byType(TransactionCard)), findsNWidgets(3));
  });

  testWidgets('la feuille affiche les états de chargement et d’erreur', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueilAvecSheet(tester, dao);
    await ouvrirLaFeuille(tester);
    expect(
      dansLaFeuille(find.byType(CircularProgressIndicator)),
      findsOneWidget,
    );

    await dao.emitError(Exception('boom'));
    await tester.pump();
    expect(
      dansLaFeuille(find.text('Impossible de charger les transactions')),
      findsOneWidget,
    );
  });

  testWidgets('le bouton fermer referme la feuille', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueilAvecSheet(
      tester,
      dao,
      transactions: [buildTransaction(id: 1)],
    );
    await ouvrirLaFeuille(tester);
    await tester.tap(dansLaFeuille(find.byTooltip('Fermer')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.byType(ListeTransactionsSheet), findsNothing);
  });

  test('le filtre est une transition explicite', () {
    expect(FiltreTransactions.toutes.libelle, 'Toutes');
    expect(
      FiltreTransactions.toutes.selectionner(FiltreTransactions.depenses),
      FiltreTransactions.depenses,
    );
    expect(
      FiltreTransactions.revenus.accepte(buildTransaction(type: 'Revenu')),
      isTrue,
    );
    expect(
      FiltreTransactions.revenus.accepte(buildTransaction(type: 'Depense')),
      isFalse,
    );
    expect(
      FiltreTransactions.depenses.accepte(buildTransaction(type: 'Depense')),
      isTrue,
    );
    expect(
      FiltreTransactions.toutes.accepte(buildTransaction(type: 'Depense')),
      isTrue,
    );
  });
}
