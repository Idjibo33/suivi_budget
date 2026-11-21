import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';

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
          create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
        ),
        ChangeNotifierProvider(create: (_) => ModifierTransactionViewProvider()),
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
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('ouvre le budget sans vérifier quand la biométrie est indisponible',
      (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(estDisponible: false);

    await pumpAccueil(tester, dao: dao, auth: auth);

    expect(find.text('MyBudget'), findsOneWidget);
    expect(find.text('Transactions récents'), findsOneWidget);
    expect(find.text('Authentification requise'), findsNothing);
    expect(find.text('Réessayer'), findsNothing);
    expect(auth.disponibiliteCalls, 1);
    expect(auth.authenticationCalls, 0);
  });

  testWidgets('affiche le budget quand l’empreinte est validée', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(
      estDisponible: true,
      result: true,
    );

    await pumpAccueil(tester, dao: dao, auth: auth);

    expect(find.text('MyBudget'), findsOneWidget);
    expect(find.text('Authentification requise'), findsNothing);
    expect(auth.disponibiliteCalls, 1);
    expect(auth.authenticationCalls, 1);
  });

  testWidgets('affiche l’écran verrouillé quand l’empreinte est refusée',
      (tester) async {
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

  testWidgets('contenu borné à 600 px et centré sur grand écran',
      (tester) async {
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

  testWidgets('gros solde sans débordement avec texte agrandi à 320 px',
      (tester) async {
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
}
