import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/views/widgets/responsive_shell.dart';

import 'fixtures/fakes.dart';

Future<void> pomperCoque(
  WidgetTester tester, {
  required FakeTransactionDao dao,
  required Size taille,
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
        ChangeNotifierProvider(create: (_) => ModifierTransactionViewProvider()),
      ],
      child: MaterialApp(
        home: ResponsiveShell(localAuth: FakeLocalAuth(estDisponible: false)),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('le téléphone garde l’accueil sans rail', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pomperCoque(tester, dao: dao, taille: const Size(390, 844));

    expect(find.byType(NavigationRail), findsNothing);
    expect(
      tester.getSize(find.byKey(const ValueKey('home_content'))).width,
      390,
    );
  });

  testWidgets('la tablette affiche un rail compact', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pomperCoque(tester, dao: dao, taille: const Size(820, 1180));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);
    expect(
      tester.getSize(find.byKey(const ValueKey('home_content'))).width,
      lessThanOrEqualTo(600),
    );
  });

  testWidgets('le desktop affiche un rail étendu avec toutes les destinations',
      (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pomperCoque(tester, dao: dao, taille: const Size(1440, 900));

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.text('Accueil'), findsOneWidget);
    expect(find.text('Ajouter'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
