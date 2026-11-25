import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/providers/database_provider.dart';

import 'fixtures/fakes.dart';

void main() {
  late FakeTransactionDao dao;
  late DatabaseProvider provider;
  late BuildContext contexte;

  Future<void> pumpProvider(WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => provider)],
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              contexte = context;
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  setUp(() {
    dao = FakeTransactionDao();
    provider = DatabaseProvider(database: dao);
  });

  test('les flux catégories et budgets alimentent le provider', () async {
    provider.listenDonneesV2();
    expect(provider.categories, isEmpty);
    expect(provider.budgets, isEmpty);

    final categories = [
      Categorie(nom: 'Alimentation', type: 'Depense', famille: 'Essentiel'),
    ];
    final budgets = [Budget(nom: 'Maison', alloue: 100000)];
    await dao.emitCategories(categories);
    await dao.emitBudgets(budgets);

    expect(provider.categories, categories);
    expect(provider.budgets, budgets);
    expect(provider.categoriesDepense, categories);
    expect(provider.categoriesRevenu, isEmpty);
  });

  test(
    'les enveloppes archivées restent consultables sans compter dans le solde',
    () async {
      provider.listenDonneesV2();

      await dao.emitBudgets([
        Budget(id: 1, nom: 'Maison', alloue: 100000),
        Budget(id: 2, nom: 'Ancienne', alloue: 70000, archive: true),
      ]);

      expect(provider.budgets.map((budget) => budget.nom), ['Maison']);
      expect(
        provider.budgetsSelon((budget) => budget.archive).map((b) => b.nom),
        ['Ancienne'],
      );
      expect(provider.totalAlloue(), 100000);
    },
  );

  test(
    'les totaux d’une enveloppe ne retiennent que ses transactions',
    () async {
      provider.listenTransactions();
      provider.listenDonneesV2();

      await dao.emit([
        buildTransaction(
          id: 1,
          montant: 20000,
          categorieId: 1,
          budgetId: 1,
          type: 'Revenu',
          date: DateTime.now().toIso8601String(),
        ),
        buildTransaction(
          id: 2,
          montant: 5000,
          categorieId: 2,
          budgetId: 1,
          type: 'Depense',
          date: DateTime.now().toIso8601String(),
        ),
        buildTransaction(
          id: 3,
          montant: 7000,
          categorieId: 2,
          budgetId: 2,
          type: 'Depense',
          date: DateTime.now().toIso8601String(),
        ),
      ]);

      final budget = Budget(id: 1, nom: 'Maison', alloue: 100000);
      final totaux = provider.totauxDuBudget(budget);

      expect(totaux.alloue, 100000);
      expect(totaux.apporte, 0);
      expect(totaux.depense, 5000);
      expect(totaux.disponible, 95000);
    },
  );

  testWidgets('le modèle d’état vide est persisté localement', (tester) async {
    provider.listenDonneesV2();
    await pumpProvider(tester);
    await provider.chargerModeleEtatVide();

    final modele = provider.modeleEtatVide.appliquerPreset(
      PresetEtatVide.encourageant,
    );
    expect(
      await provider.enregistrerModeleEtatVide(contexte, modele: modele),
      isTrue,
    );

    expect(provider.modeleEtatVide.titre, modele.titre);
    expect(dao.parametres, containsPair(cleModeleEtatVide, isNotNull));

    final deuxiemeProvider = DatabaseProvider(database: dao);
    await deuxiemeProvider.chargerModeleEtatVide();
    expect(deuxiemeProvider.modeleEtatVide.titre, modele.titre);
    expect(deuxiemeProvider.modeleEtatVide.preset, PresetEtatVide.encourageant);
  });

  testWidgets('une catégorie et un budget peuvent être créés', (tester) async {
    await pumpProvider(tester);

    expect(
      await provider.ajouterCategorie(
        contexte,
        categorie: Categorie(
          nom: 'Cinéma',
          type: 'Depense',
          famille: 'Loisirs',
        ),
      ),
      isTrue,
    );
    expect(
      await provider.ajouterBudget(
        contexte,
        budget: Budget(nom: 'Sorties', alloue: 20000),
      ),
      isTrue,
    );

    expect(dao.addedCategories.single.nom, 'Cinéma');
    expect(dao.addedBudgets.single.nom, 'Sorties');
  });

  testWidgets(
    'renommer et archiver une catégorie passent par des transitions',
    (tester) async {
      await pumpProvider(tester);
      final categorie = Categorie(id: 4, nom: 'Cinéma', type: 'Depense');

      expect(
        await provider.renommerCategorie(
          contexte,
          categorie: categorie,
          nouveauNom: 'Spectacles',
        ),
        isTrue,
      );
      final Categorie renommee = categorie.renommer('Spectacles');
      expect(
        await provider.archiverCategorie(contexte, categorie: renommee),
        isTrue,
      );

      expect(renommee.nom, 'Spectacles');
      expect(renommee.personnalisee, isTrue);
      expect(dao.updatedCategories.last.archive, isTrue);
      expect(dao.updatedCategories.map((c) => c.nom), [
        'Spectacles',
        'Spectacles',
      ]);
    },
  );

  testWidgets('archiver un budget passe par une transition nommée', (
    tester,
  ) async {
    await pumpProvider(tester);
    final budget = Budget(id: 2, nom: 'Voyage', alloue: 50000);

    expect(await provider.archiverBudget(contexte, budget: budget), isTrue);

    expect(dao.updatedBudgets.single.archive, isTrue);
    expect(dao.updatedBudgets.single.createdAt, budget.createdAt);
  });

  test('le nombre d’utilisations d’une catégorie vient du DAO', () async {
    final categorie = Categorie(id: 7, nom: 'Courses', type: 'Depense');
    dao.usagesCategories[7] = 3;

    expect(await provider.nombreTransactionsCategorie(categorie), 3);
  });
}
