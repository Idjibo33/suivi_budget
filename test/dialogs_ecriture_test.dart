import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/widgets/creer_budget_dialog.dart';
import 'package:suivi_budget/views/budgets/widgets/empty_state_editor.dart';

import 'fixtures/fakes.dart';

/// DAO de test : seul l'ajout de budget ou l'écriture du paramètre échoue.
class DaoDialoguesEnEchec extends FakeTransactionDao {
  final bool echecBudget;
  final bool echecParametre;

  DaoDialoguesEnEchec({this.echecBudget = false, this.echecParametre = false});

  @override
  Future<void> addBudget(Budget budget) async {
    if (echecBudget) {
      throw Exception('échec budget');
    }
    await super.addBudget(budget);
  }

  @override
  Future<void> ecrireParametre(String cle, String valeur) async {
    if (echecParametre) {
      throw Exception('échec parametre');
    }
    await super.ecrireParametre(cle, valeur);
  }
}

Future<BuildContext> pomperDialogue(
  WidgetTester tester,
  DatabaseProvider provider,
  Widget dialogue,
) async {
  tester.view.physicalSize = const Size(1200, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  late BuildContext contexte;
  await tester.pumpWidget(
    ChangeNotifierProvider<DatabaseProvider>.value(
      value: provider,
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            contexte = context;
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
      ),
    ),
  );
  unawaited(showDialog<void>(context: contexte, builder: (_) => dialogue));
  await tester.pump();
  await tester.pump();
  return contexte;
}

void main() {
  testWidgets('création de budget en échec : dialogue et saisie conservés', (
    tester,
  ) async {
    final dao = DaoDialoguesEnEchec(echecBudget: true);
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    await pomperDialogue(tester, provider, const CreerBudgetDialog());

    await tester.enterText(
      find.widgetWithText(TextField, 'Nom du budget'),
      'Voyage',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Plafond de dépenses'),
      '50000',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Créer'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Nouveau budget'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.widgetWithText(TextField, 'Nom du budget'))
          .controller!
          .text,
      'Voyage',
    );
    expect(
      tester
          .widget<TextField>(
            find.widgetWithText(TextField, 'Plafond de dépenses'),
          )
          .controller!
          .text,
      '50000',
    );
    expect(dao.addedBudgets, isEmpty);
    expect(find.textContaining('Budget créé'), findsNothing);
    expect(find.textContaining('échec budget'), findsOneWidget);
  });

  testWidgets('création de budget réussie : le dialogue se ferme', (
    tester,
  ) async {
    final dao = DaoDialoguesEnEchec();
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    await pomperDialogue(tester, provider, const CreerBudgetDialog());

    await tester.enterText(
      find.widgetWithText(TextField, 'Nom du budget'),
      'Voyage',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Plafond de dépenses'),
      '50000',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Créer'));
    await tester.pump();
    await tester.pump();

    expect(dao.addedBudgets, hasLength(1));
    expect(find.text('Nouveau budget'), findsNothing);
  });

  testWidgets('modèle d’état vide en échec : dialogue et saisie conservés', (
    tester,
  ) async {
    final dao = DaoDialoguesEnEchec(echecParametre: true);
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    await pomperDialogue(tester, provider, const EmptyStateEditor());
    final titreInitial = provider.modeleEtatVide.titre;
    final Finder champTitre = find.widgetWithText(TextField, 'Titre');

    await tester.enterText(champTitre, 'Titre modifié');
    await tester.pump();
    expect(provider.modeleEtatVide.titre, titreInitial);

    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Personnaliser l’état vide'), findsOneWidget);
    expect(
      tester.widget<TextField>(champTitre).controller!.text,
      'Titre modifié',
    );
    expect(provider.modeleEtatVide.titre, titreInitial);
    expect(dao.parametres, isEmpty);
    expect(find.textContaining('Modèle d’état vide enregistré'), findsNothing);
  });

  testWidgets('modèle d’état vide réussi : le dialogue se ferme', (
    tester,
  ) async {
    final dao = DaoDialoguesEnEchec();
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    await pomperDialogue(tester, provider, const EmptyStateEditor());

    await tester.enterText(
      find.widgetWithText(TextField, 'Titre'),
      'Titre modifié',
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Personnaliser l’état vide'), findsNothing);
    expect(provider.modeleEtatVide.titre, 'Titre modifié');
  });
}
