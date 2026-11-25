import 'package:suivi_budget/models/etats/etat_onglet_transaction.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/etats/etat_navigation.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/providers/theme_provider.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/responsive_shell.dart';

import 'fixtures/fakes.dart';

Future<void> pomperNavigationMobile(
  WidgetTester tester, {
  required FakeTransactionDao dao,
  required FakeLocalAuth auth,
  Size taille = const Size(390, 844),
}) async {
  tester.view.physicalSize = taille;
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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(home: ResponsiveShell(localAuth: auth)),
    ),
  );
  await tester.pump();
  await tester.pump();
}

Finder onglet(String libelle) => find.descendant(
  of: find.byType(NavigationBar),
  matching: find.text(libelle),
);

/// `byTooltip` cible aussi `RawTooltip` sous Flutter 3.50 : on préfère l'action.
Finder bouton(String tooltip) => find.byWidgetPredicate(
  (widget) => widget is IconButton && widget.tooltip == tooltip,
);

/// Les écrans Budgets/Analyses portent des animations continues : on avance
/// explicitement le temps au lieu d'attendre une fin de frame impossible.
Future<void> pumpTransition(WidgetTester tester) async {
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pump();
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('le mobile affiche une barre à trois destinations sans rail', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(estDisponible: false);

    await pomperNavigationMobile(tester, dao: dao, auth: auth);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).destinations,
      hasLength(3),
    );
    expect(onglet('Accueil'), findsOneWidget);
    expect(onglet('Budgets'), findsOneWidget);
    expect(onglet('Profil'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('home_content'))).width,
      390,
    );
  });

  for (final (libelle, onglet) in [
    ('Ajouter une dépense', EtatOngletTransaction.depense),
    ('Ajouter un revenu', EtatOngletTransaction.revenu),
  ]) {
    testWidgets('$libelle est visible et ouvre le bon formulaire', (tester) async {
      final dao = FakeTransactionDao();
      addTearDown(dao.close);
      await pomperNavigationMobile(tester, dao: dao, auth: FakeLocalAuth(estDisponible: false));
      final action = find.text(libelle).hitTestable();
      expect(action, findsOneWidget);
      await tester.tap(action);
      await pumpTransition(tester);
      final formulaire = tester.widget<AjouterTransaction>(find.byType(AjouterTransaction));
      expect(formulaire.ongletInitial, onglet);
    });
  }

  testWidgets('les onglets changent l’enfant sans pousser de route', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final FakeLocalAuth auth = FakeLocalAuth(estDisponible: false);

    await pomperNavigationMobile(tester, dao: dao, auth: auth);
    final int appelsAvant = auth.disponibiliteCalls;

    await tester.tap(onglet('Budgets'));
    await pumpTransition(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(BudgetsScreen), findsOneWidget);
    expect(find.text('Budgets & analyses'), findsOneWidget);
    expect(find.byKey(const ValueKey('home_content')), findsNothing);

    await tester.tap(onglet('Profil'));
    await pumpTransition(tester);

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(BudgetsScreen), findsNothing);
    expect(find.text('Apparence'), findsOneWidget);

    await tester.tap(bouton('Fermer'));
    await pumpTransition(tester);

    expect(find.byKey(const ValueKey('home_content')), findsOneWidget);
    expect(find.text('Apparence'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);

    // L’état de l’accueil (authentification comprise) est conservé : IndexedStack
    // ne recrée pas l’écran lors des changements d’onglet.
    expect(auth.disponibiliteCalls, appelsAvant);
    expect(auth.authenticationCalls, 0);
  });

  testWidgets('l’onglet Accueil ramène à l’accueil après le profil', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pomperNavigationMobile(
      tester,
      dao: dao,
      auth: FakeLocalAuth(estDisponible: false),
    );

    await tester.tap(onglet('Profil'));
    await pumpTransition(tester);
    expect(find.text('Apparence'), findsOneWidget);

    await tester.tap(onglet('Accueil'));
    await pumpTransition(tester);

    expect(find.byKey(const ValueKey('home_content')), findsOneWidget);
    expect(find.text('Apparence'), findsNothing);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets(
    'le profil mobile reste accessible depuis son onglet sans raccourci doublon',
    (tester) async {
      final FakeTransactionDao dao = FakeTransactionDao();
      addTearDown(dao.close);

      await pomperNavigationMobile(
        tester,
        dao: dao,
        auth: FakeLocalAuth(estDisponible: false),
      );

      expect(bouton('Profil'), findsNothing);
      expect(bouton('Budgets'), findsNothing);
      await tester.tap(onglet('Profil'));
      await pumpTransition(tester);
      expect(find.text('Apparence'), findsOneWidget);

      await tester.tap(bouton('Fermer'));
      await pumpTransition(tester);

      expect(find.byType(Drawer), findsNothing);
      expect(find.byKey(const ValueKey('home_content')), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  test('le rail conserve ses quatre destinations historiques', () {
    expect(EtatNavigation.depuisIndex(0), EtatNavigation.accueil);
    expect(EtatNavigation.depuisIndex(1), EtatNavigation.budgets);
    expect(EtatNavigation.depuisIndex(2), EtatNavigation.ajouter);
    expect(EtatNavigation.depuisIndex(3), EtatNavigation.profil);
    expect(EtatNavigation.depuisIndex(4), EtatNavigation.accueil);
  });

  test('la barre mobile ne compte que trois onglets', () {
    expect(EtatNavigation.destinationsMobile, [
      EtatNavigation.accueil,
      EtatNavigation.budgets,
      EtatNavigation.profil,
    ]);
    expect(EtatNavigation.accueil.indexMobile, 0);
    expect(EtatNavigation.budgets.indexMobile, 1);
    expect(EtatNavigation.ajouter.indexMobile, 0);
    expect(EtatNavigation.profil.indexMobile, 2);
    expect(EtatNavigation.depuisIndexMobile(0), EtatNavigation.accueil);
    expect(EtatNavigation.depuisIndexMobile(1), EtatNavigation.budgets);
    expect(EtatNavigation.depuisIndexMobile(2), EtatNavigation.profil);
    expect(EtatNavigation.depuisIndexMobile(3), EtatNavigation.accueil);
    expect(EtatNavigation.depuisIndexMobile(-1), EtatNavigation.accueil);
  });

  testWidgets('le profil en onglet appelle onFermer sans chercher de tiroir', (
    tester,
  ) async {
    int fermetures = 0;

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: ThemeProvider(),
        child: MaterialApp(home: ProfilScreen(onFermer: () => fermetures++)),
      ),
    );

    await tester.tap(bouton('Fermer'));
    await tester.pump();

    expect(fermetures, 1);
    expect(tester.takeException(), isNull);
  });
}
