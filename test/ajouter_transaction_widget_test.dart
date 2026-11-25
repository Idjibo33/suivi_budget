import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/etats/etat_onglet_transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

import 'fixtures/fakes.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  Future<void> pumpFormulaire(WidgetTester tester, FakeTransactionDao dao) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => DatabaseProvider(database: dao)
          ..listenTransactions()
          ..listenDonneesV2(),
        child: const MaterialApp(home: AjouterTransaction()),
      ),
    );
    await tester.pump();
    await emitDonneesV2ParDefaut(dao);
    await tester.pump();
  }

  testWidgets('bascule entre revenu et dépense sans TabController',
      (tester) async {
    final FakeTransactionDao dao = FakeTransactionDao();
    addTearDown(dao.close);

    await pumpFormulaire(tester, dao);

    expect(find.text('Ajouter une transaction'), findsOneWidget);
    expect(find.text('MONTANTS FRÉQUENTS'), findsOneWidget);
    expect(find.byType(TabBarView), findsNothing);

    SegmentedButton<EtatOngletTransaction> selecteur =
        tester.widget<SegmentedButton<EtatOngletTransaction>>(
      find.byType(SegmentedButton<EtatOngletTransaction>),
    );
    expect(selecteur.selected, {EtatOngletTransaction.revenu});

    await tester.tap(find.text('Dépense'));
    await tester.pump();

    selecteur = tester.widget<SegmentedButton<EtatOngletTransaction>>(
      find.byType(SegmentedButton<EtatOngletTransaction>),
    );
    expect(selecteur.selected, {EtatOngletTransaction.depense});
    expect(tester.takeException(), isNull);
  });
}
