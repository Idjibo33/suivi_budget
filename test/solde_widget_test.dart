import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/widgets/solde_widget.dart';

import 'fixtures/fakes.dart';

Future<void> pomperSolde(WidgetTester tester, FakeTransactionDao dao) async {
  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => DatabaseProvider(database: dao)..listenTransactions(),
      child: const MaterialApp(home: Scaffold(body: SoldeWidget())),
    ),
  );
  final now = DateTime.now();
  final mois = DateTime(now.year, now.month).toIso8601String();
  await dao.emit([
    buildTransaction(
      montant: 123456,
      type: 'Revenu',
      date: DateTime(now.year, now.month - 1).toIso8601String(),
    ),
    buildTransaction(montant: 1000, date: mois),
    buildTransaction(montant: 7890, type: 'Depense', date: mois),
  ]);
  await tester.pump();
}

void main() {
  testWidgets('distingue le solde global des opérations du mois', (
    tester,
  ) async {
    final dao = FakeTransactionDao();
    addTearDown(dao.close);
    await pomperSolde(tester, dao);
    expect(find.text('Solde actuel'), findsOneWidget);
    expect(find.text('Revenus du mois'), findsOneWidget);
    expect(find.text('Dépenses du mois'), findsOneWidget);
    expect(find.text(FormatMontant.afficherAvecDevise(116566)), findsOneWidget);
    expect(find.text('+1 000 F CFA'), findsOneWidget);
    expect(find.text('-7 890 F CFA'), findsOneWidget);
  });

  testWidgets('masquer le solde remplace uniquement le montant affiché', (
    tester,
  ) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pomperSolde(tester, dao);
    expect(find.text('******'), findsNothing);

    await tester.tap(find.byTooltip('Masquer le solde'));
    await tester.pump();

    expect(find.text('******'), findsOneWidget);
    expect(find.text(FormatMontant.afficherAvecDevise(116566)), findsNothing);
    expect(find.byIcon(Icons.visibility), findsOneWidget);

    await tester.tap(find.byTooltip('Afficher le solde'));
    await tester.pump();

    expect(find.text('******'), findsNothing);
    expect(find.text(FormatMontant.afficherAvecDevise(116566)), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off), findsOneWidget);
  });
}
