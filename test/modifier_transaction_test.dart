import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/modifier_transaction.dart';

import 'fixtures/fakes.dart';

Future<void> pumpModifier(
  WidgetTester tester,
  FakeTransactionDao dao,
  Transaction transaction,
) async {
  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModifierTransactionViewProvider()),
        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
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
}

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('enregistre les modifications saisies', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);
    final Transaction original = buildTransaction(
      id: 7,
      montant: 1000,
      description: 'Ancienne description',
      category: 'Salaire',
      type: 'Revenu',
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

    expect(dao.updated, hasLength(1));
    final Transaction updated = dao.updated.single;
    expect(updated.id, 7);
    expect(updated.montant, 2500);
    expect(updated.description, 'Nouvelle description');
    expect(updated.category, 'Salaire');
    expect(updated.type, 'Revenu');
    expect(updated.date, '2026-10-19 08:00:00.000');

    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('montant invalide : aucun enregistrement', (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpModifier(
      tester,
      dao,
      buildTransaction(id: 7, montant: 1000),
    );

    await tester.enterText(find.byType(TextField).at(0), '');
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 4));

    expect(dao.updated, isEmpty);
  });
}
