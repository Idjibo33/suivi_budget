import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

import 'fixtures/fakes.dart';

void main() {
  setUpAll(() async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await initializeDateFormatting('fr_FR');
  });

  testWidgets('catégorie longue tronquée sans débordement', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    const String categorie =
        'AchatNourritureBoissonsDuMoisPourTouteLaFamille';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TransactionCard(
            transaction: buildTransaction(category: categorie),
          ),
        ),
      ),
    );

    final Text categoryText = tester.widget<Text>(find.text(categorie));

    expect(categoryText.maxLines, 1);
    expect(categoryText.overflow, TextOverflow.ellipsis);
    expect(tester.takeException(), isNull);
  });

  testWidgets('affiche la date au format jj/MM/aaaa', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TransactionCard(
            transaction: buildTransaction(date: '2026-10-19 08:00:00.000'),
          ),
        ),
      ),
    );

    expect(find.text('19/10/2026'), findsOneWidget);
  });
}
