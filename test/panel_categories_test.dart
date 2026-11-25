import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/widgets/panel_categories.dart';

import 'fixtures/fakes.dart';

class DaoCategorieEnEchec extends FakeTransactionDao {
  @override
  Future<void> addCategorie(Categorie categorie) async {
    throw Exception('échec categorie');
  }
}

class DaoRenommageEnEchec extends FakeTransactionDao {
  @override
  Future<void> editCategorie(Categorie categorie) async {
    throw Exception('échec renommage');
  }
}

Future<void> pomperPanel(
  WidgetTester tester,
  FakeTransactionDao dao,
  DatabaseProvider provider,
) async {
  await tester.pumpWidget(
    ChangeNotifierProvider<DatabaseProvider>.value(
      value: provider,
      child: const MaterialApp(home: Scaffold(body: SingleChildScrollView(
        child: PanelCategories(),
      ))),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('les catégories « Autre » ne peuvent pas être archivées',
      (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)
      ..listenDonneesV2();
    addTearDown(dao.close);

    await dao.emitCategories([
      Categorie(
        id: 1,
        nom: 'Autre',
        type: 'Depense',
        famille: 'Autre',
      ),
      Categorie(id: 2, nom: 'Cinéma', type: 'Depense', famille: 'Loisirs'),
    ]);

    await pomperPanel(tester, dao, provider);

    final Finder autres = find.ancestor(
      of: find.text('Autre'),
      matching: find.byType(ListTile),
    );
    final IconButton archiveAutre = tester.widget<IconButton>(
      find.ancestor(
        of: find.descendant(
          of: autres,
          matching: find.byTooltip('Catégorie « Autre » toujours disponible'),
        ),
        matching: find.byType(IconButton),
      ),
    );
    expect(archiveAutre.onPressed, isNull);

    final Finder cinema = find.ancestor(
      of: find.text('Cinéma'),
      matching: find.byType(ListTile),
    );
    final IconButton archiveCinema = tester.widget<IconButton>(
      find.ancestor(
        of: find.descendant(
          of: cinema,
          matching: find.byTooltip('Archiver'),
        ),
        matching: find.byType(IconButton),
      ),
    );
    expect(archiveCinema.onPressed, isNotNull);

    // Une catégorie utilisée est archivée, pas supprimée.
    dao.usagesCategories[2] = 3;
    await tester.tap(find.descendant(
      of: cinema,
      matching: find.byTooltip('Archiver'),
    ));
    await tester.pump();
    await tester.pump();

    expect(dao.updatedCategories, hasLength(1));
    expect(dao.updatedCategories.single.archive, isTrue);
  });

  testWidgets('les catégories « Autre » ne peuvent pas être renommées',
      (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)..listenDonneesV2();
    addTearDown(dao.close);
    await dao.emitCategories([
      Categorie(id: 1, nom: 'Autre', type: 'Depense', famille: 'Autre'),
      Categorie(
        id: 2,
        nom: 'Autre revenu',
        type: 'Revenu',
        famille: 'Revenus',
      ),
    ]);

    await pomperPanel(tester, dao, provider);

    for (final String nom in ['Autre', 'Autre revenu']) {
      final Finder ligne = find.ancestor(
        of: find.text(nom),
        matching: find.byType(ListTile),
      );
      final IconButton bouton = tester.widget<IconButton>(
        find.ancestor(
          of: find.descendant(
            of: ligne,
            matching: find.byTooltip('Catégorie « Autre » : renommage impossible'),
          ),
          matching: find.byType(IconButton),
        ),
      );
      expect(bouton.onPressed, isNull);
    }
  });

  testWidgets('un nom vide est refusé avec un message', (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)..listenDonneesV2();
    addTearDown(dao.close);
    await pomperPanel(tester, dao, provider);

    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter la catégorie'));
    await tester.pump();

    expect(find.text('Le nom de la catégorie ne peut pas être vide'),
        findsOneWidget);
    expect(dao.addedCategories, isEmpty);
  });

  testWidgets('échec d’ajout : la saisie est conservée', (tester) async {
    final DaoCategorieEnEchec dao = DaoCategorieEnEchec();
    final provider = DatabaseProvider(database: dao)..listenDonneesV2();
    addTearDown(dao.close);
    await pomperPanel(tester, dao, provider);

    await tester.enterText(
      find.widgetWithText(TextField, 'Nouvelle catégorie'),
      'Cinéma',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Famille (graphiques)'),
      'Loisirs',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Ajouter la catégorie'));
    await tester.pump();
    await tester.pump();

    expect(dao.addedCategories, isEmpty);
    expect(
      tester.widget<TextField>(
        find.widgetWithText(TextField, 'Nouvelle catégorie'),
      ).controller!.text,
      'Cinéma',
    );
    expect(
      tester.widget<TextField>(
        find.widgetWithText(TextField, 'Famille (graphiques)'),
      ).controller!.text,
      'Loisirs',
    );
    expect(find.textContaining('échec categorie'), findsOneWidget);
  });

  testWidgets('échec de renommage : la saisie est conservée',
      (tester) async {
    final DaoRenommageEnEchec dao = DaoRenommageEnEchec();
    final provider = DatabaseProvider(database: dao)..listenDonneesV2();
    addTearDown(dao.close);
    await dao.emitCategories([
      Categorie(id: 2, nom: 'Cinéma', type: 'Depense', famille: 'Loisirs'),
    ]);
    await pomperPanel(tester, dao, provider);

    final Finder cinema = find.ancestor(
      of: find.text('Cinéma'),
      matching: find.byType(ListTile),
    );
    await tester.tap(find.descendant(
      of: cinema,
      matching: find.byTooltip('Renommer'),
    ));
    await tester.pump();
    final Finder champ = find.byType(TextField).last;
    await tester.enterText(champ, 'Spectacles');
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(dao.updatedCategories, isEmpty);
    expect(find.text('Renommer la catégorie'), findsOneWidget);
    expect(tester.widget<TextField>(champ).controller!.text, 'Spectacles');
    expect(find.textContaining('Catégorie renommée'), findsNothing);
  });

  testWidgets('renommage vide : message et dialogue maintenu', (tester) async {
    final dao = FakeTransactionDao();
    final provider = DatabaseProvider(database: dao)..listenDonneesV2();
    addTearDown(dao.close);
    await dao.emitCategories([
      Categorie(id: 2, nom: 'Cinéma', type: 'Depense', famille: 'Loisirs'),
    ]);
    await pomperPanel(tester, dao, provider);

    final Finder cinema = find.ancestor(
      of: find.text('Cinéma'),
      matching: find.byType(ListTile),
    );
    await tester.tap(find.descendant(
      of: cinema,
      matching: find.byTooltip('Renommer'),
    ));
    await tester.pump();

    expect(find.text('Renommer la catégorie'), findsOneWidget);
    final Finder champ = find.byType(TextField).last;
    await tester.enterText(champ, '   ');
    await tester.tap(find.widgetWithText(FilledButton, 'Enregistrer'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Renommer la catégorie'), findsOneWidget);
    expect(find.text('Le nom de la catégorie ne peut pas être vide'),
        findsOneWidget);
    expect(
      tester.widget<TextField>(champ).controller!.text,
      '   ',
    );
    expect(dao.updatedCategories, isEmpty);
  });
}
