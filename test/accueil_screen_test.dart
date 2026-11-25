import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/budgets/widgets/budget_card.dart';
import 'package:suivi_budget/views/budgets/widgets/empty_state_editor.dart';
import 'package:suivi_budget/views/widgets/liste_transactions_sheet.dart';

import 'fixtures/fakes.dart';

Future<void> pumpAccueil(
  WidgetTester tester, {
  required FakeTransactionDao dao,
  FakeLocalAuth? auth,
  Size size = const Size(390, 844),
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)
            ..listenTransactions()
            ..listenDonneesV2(),
        ),
        ChangeNotifierProvider(
          create: (_) => ModifierTransactionViewProvider(),
        ),
      ],
      child: MaterialApp(home: AccueilScreen(localAuth: auth)),
    ),
  );
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets(
    'ouvre le budget sans vérifier quand la biométrie est indisponible',
    (tester) async {
      final FakeTransactionDao dao = FakeTransactionDao();
      addTearDown(dao.close);
      final FakeLocalAuth auth = FakeLocalAuth(estDisponible: false);

      await pumpAccueil(tester, dao: dao, auth: auth);

      expect(find.text('MyBudget'), findsOneWidget);
      expect(find.text('Mes budgets'), findsOneWidget);
      expect(find.text('Transactions récentes'), findsOneWidget);
      expect(find.text('Authentification requise'), findsNothing);
      expect(find.text('Réessayer'), findsNothing);
      expect(auth.disponibiliteCalls, 1);
      expect(auth.authenticationCalls, 0);
    },
  );

  testWidgets('affiche le budget quand l’empreinte est validée', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(estDisponible: true, result: true);

    await pumpAccueil(tester, dao: dao, auth: auth);

    expect(find.text('MyBudget'), findsOneWidget);
    expect(find.text('Authentification requise'), findsNothing);
    expect(auth.disponibiliteCalls, 1);
    expect(auth.authenticationCalls, 1);
  });

  testWidgets('affiche l’écran verrouillé quand l’empreinte est refusée', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(
      estDisponible: true,
      result: false,
    );

    await pumpAccueil(tester, dao: dao, auth: auth);

    expect(find.text('Authentification requise'), findsOneWidget);
    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.text('MyBudget'), findsNothing);
    expect(auth.authenticationCalls, 1);
  });

  testWidgets('réessayer après un refus rouvre le budget', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(
      estDisponible: true,
      result: false,
    );

    await pumpAccueil(tester, dao: dao, auth: auth);
    expect(find.text('Authentification requise'), findsOneWidget);

    auth.result = true;
    await tester.tap(find.text('Réessayer'));
    await tester.pump();
    await tester.pump();
    await tester.pump();

    expect(find.text('MyBudget'), findsOneWidget);
    expect(find.text('Authentification requise'), findsNothing);
    expect(auth.authenticationCalls, 2);
  });

  testWidgets('contenu borné à 600 px et centré sur grand écran', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
      size: const Size(1440, 900),
    );

    final Finder content = find.byKey(const ValueKey('home_content'));

    expect(tester.getSize(content).width, 600);
    expect(tester.getRect(content).left, (1440 - 600) / 2);
  });

  testWidgets('pleine largeur sur petit écran', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
      size: const Size(360, 640),
    );

    expect(
      tester.getSize(find.byKey(const ValueKey('home_content'))).width,
      360,
    );
  });

  testWidgets('solde compact sans débordement avec texte agrandi à 320 px', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
      size: const Size(320, 700),
      textScale: 1.3,
    );
    await dao.emit([buildTransaction(montant: 999999999, type: 'Revenu')]);
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('voir tout ouvre la liste complète dans une feuille', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );
    await dao.emit([buildTransaction(id: 1)]);
    await tester.pump();

    expect(find.byType(ListeTransactionsSheet), findsNothing);
    await tester.ensureVisible(find.text('Voir tout'));
    await tester.tap(find.text('Voir tout'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(ListeTransactionsSheet), findsOneWidget);
  });

  testWidgets('le solde se masque avec la bonne icône', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );

    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();

    expect(find.text('******'), findsOneWidget);
    expect(find.byIcon(Icons.visibility), findsOneWidget);
  });

  testWidgets('affiche les enveloppes actives avant les transactions', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );
    await dao.emitBudgets([
      Budget(id: 1, nom: 'Maison', alloue: 100000),
      Budget(id: 2, nom: 'Archivée', alloue: 5000, archive: true),
    ]);
    await tester.pump();

    expect(find.byType(BudgetCard), findsOneWidget);
    expect(find.text('Maison'), findsOneWidget);
    expect(find.text('Archivée'), findsNothing);
    expect(find.text('Mes budgets'), findsOneWidget);
    expect(find.text('Transactions récentes'), findsOneWidget);
    expect(find.text('Voir tout'), findsOneWidget);
    expect(
      find.widgetWithText(FilledButton, 'Ajouter une dépense'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(OutlinedButton, 'Ajouter un revenu'),
      findsOneWidget,
    );

    expect(
      tester.getRect(find.text('Solde actuel')).top,
      lessThan(tester.getRect(find.text('Mes budgets')).top),
    );
    expect(
      tester.getRect(find.text('Mes budgets')).top,
      lessThan(tester.getRect(find.text('Transactions récentes')).top),
    );
  });

  testWidgets('un tap sur une enveloppe ouvre l’écran Budgets', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );
    await dao.emitBudgets([Budget(id: 1, nom: 'Maison', alloue: 100000)]);
    await tester.pump();

    expect(find.byType(BudgetsScreen), findsNothing);
    await tester.tap(find.byType(BudgetCard));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(BudgetsScreen), findsOneWidget);
  });

  testWidgets('sans enveloppe active, la carte vide crée un budget', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );
    await dao.emitBudgets([]);
    await tester.pump();

    expect(find.byType(BudgetCard), findsNothing);
    expect(find.textContaining('Un budget fixe une limite'), findsNothing);
    final description = tester.widget<Text>(
      find.textContaining('Choisissez un modèle'),
    );
    expect(description.style?.fontWeight, FontWeight.w400);
    expect(find.text('Transport'), findsOneWidget);

    // La création libre et le modèle ouvrent le même formulaire.
    final creer = find.widgetWithText(
      FilledButton,
      'Créer un budget personnalisé',
    );
    await tester.ensureVisible(creer);
    await tester.tap(creer);
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Annuler'));
    await tester.pump();

    await tester.ensureVisible(find.text('Transport'));
    await tester.tap(find.text('Transport'));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('la personnalisation du message reste accessible dans Budgets', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpAccueil(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );
    await dao.emitBudgets([]);
    await tester.pump();

    expect(find.text('Personnaliser le modèle'), findsNothing);
    await tester.tap(find.text('Gérer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Personnaliser'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byType(EmptyStateEditor), findsOneWidget);
  });
}
