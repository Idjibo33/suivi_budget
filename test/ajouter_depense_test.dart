import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/views/Transactions/Depenses/ajouter_depense_view.dart';

import 'fixtures/fakes.dart';

Future<void> pumpDepense(WidgetTester tester, FakeTransactionDao dao) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: AjouterDepenseView()),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('montant vide : aucun ajout et pas de crash', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpDepense(tester, dao);
    await dao.emit([buildTransaction(montant: 10000, type: 'Revenu')]);
    await tester.pump();

    await tester.tap(find.text('Enregistrer transaction'));
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
    await tester.tap(find.text('Enregistrer transaction'));
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
    await tester.tap(find.text('Enregistrer transaction'));
    await tester.pump();
    await tester.pump();

    expect(dao.added, hasLength(1));
    expect(dao.added.single.montant, 5000);
    expect(dao.added.single.type, 'Depense');

    await tester.pump(const Duration(seconds: 4));
  });
}
