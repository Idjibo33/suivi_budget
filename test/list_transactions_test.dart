import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/views/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

import 'fixtures/fakes.dart';

Future<void> pumpListe(WidgetTester tester, FakeTransactionDao dao) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
        ),
      ],
      child: const MaterialApp(
        home: Scaffold(body: ListTransactionsWidgets()),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('affiche un indicateur pendant le chargement', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpListe(tester, dao);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Aucune transaction trouvée'), findsNothing);
  });

  testWidgets('affiche le message vide après chargement', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpListe(tester, dao);
    await dao.emit([]);
    await tester.pump();

    expect(find.text('Aucune transaction trouvée'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('affiche les transactions reçues', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpListe(tester, dao);
    await dao.emit([buildTransaction(id: 1), buildTransaction(id: 2)]);
    await tester.pump();

    expect(find.byType(TransactionCard), findsNWidgets(2));
  });

  testWidgets('affiche une erreur conviviale', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpListe(tester, dao);
    await dao.emitError(Exception('boom'));
    await tester.pump();

    expect(
      find.text('Impossible de charger les transactions'),
      findsOneWidget,
    );
  });
}
