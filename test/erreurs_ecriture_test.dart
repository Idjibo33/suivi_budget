import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/etats/etat_operation.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';

import 'fixtures/fakes.dart';

/// DAO de test qui simule un échec de writing sur les opérations choisies.
class DaoEnEchec extends FakeTransactionDao {
  DaoEnEchec(this.operationsEnEchec);

  final Set<String> operationsEnEchec;

  Future<void> _verifier(String operation) async {
    if (operationsEnEchec.contains(operation)) {
      throw Exception('échec $operation');
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _verifier('ajouter');
    await super.addTransaction(transaction);
  }

  @override
  Future<void> editTransaction(Transaction transaction) async {
    await _verifier('modifier');
    await super.editTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    await _verifier('supprimer');
    await super.deleteTransaction(id);
  }

  @override
  Future<void> addCategorie(Categorie categorie) async {
    await _verifier('categorie');
    await super.addCategorie(categorie);
  }

  @override
  Future<void> editCategorie(Categorie categorie) async {
    await _verifier('categorie');
    await super.editCategorie(categorie);
  }

  @override
  Future<void> addBudget(Budget budget) async {
    await _verifier('budget');
    await super.addBudget(budget);
  }

  @override
  Future<void> editBudget(Budget budget) async {
    await _verifier('budget');
    await super.editBudget(budget);
  }

  @override
  Future<void> ecrireParametre(String cle, String valeur) async {
    await _verifier('parametre');
    await super.ecrireParametre(cle, valeur);
  }
}

Future<BuildContext> pomperContexte(
  WidgetTester tester,
  DatabaseProvider provider,
) async {
  late BuildContext contexte;
  await tester.pumpWidget(
    ChangeNotifierProvider<DatabaseProvider>.value(
      value: provider,
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
  return contexte;
}

void main() {
  testWidgets('les écritures de transaction signalent succès ou échec',
      (tester) async {
    final dao = DaoEnEchec(const {'ajouter', 'modifier', 'supprimer'});
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    final BuildContext contexte = await pomperContexte(tester, provider);
    final Transaction transaction = buildTransaction(id: 3);

    final bool ajout = await provider.addTransaction(
      contexte,
      transaction: transaction,
    );
    final bool modification = await provider.updateTransaction(
      contexte,
      transaction: transaction,
    );
    final bool suppression = await provider.delteTransaction(contexte, id: 3);

    expect(ajout, isFalse);
    expect(modification, isFalse);
    expect(suppression, isFalse);
    expect(dao.added, isEmpty);
    expect(dao.updated, isEmpty);
    expect(dao.deleted, isEmpty);
    expect(provider.etatOperation, isA<EtatOperationEchec>());

    final daoOK = DaoEnEchec(const {});
    addTearDown(daoOK.close);
    final providerOK = DatabaseProvider(database: daoOK);
    final BuildContext contexteOK = await pomperContexte(tester, providerOK);

    expect(
      await providerOK.addTransaction(contexteOK, transaction: transaction),
      isTrue,
    );
    expect(
      await providerOK.updateTransaction(contexteOK, transaction: transaction),
      isTrue,
    );
    expect(await providerOK.delteTransaction(contexteOK, id: 3), isTrue);
    expect(providerOK.etatOperation, isA<EtatOperationSucces>());
  });

  testWidgets('les écritures V2 signalent succès ou échec', (tester) async {
    final dao = DaoEnEchec(const {'categorie', 'budget'});
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    final BuildContext contexte = await pomperContexte(tester, provider);
    final Categorie categorie = Categorie(id: 4, nom: 'Cinéma', type: 'Depense');
    final Budget budget = Budget(id: 2, nom: 'Voyage', alloue: 1000);

    expect(
      await provider.ajouterCategorie(contexte, categorie: categorie),
      isFalse,
    );
    expect(
      await provider.renommerCategorie(
        contexte,
        categorie: categorie,
        nouveauNom: 'Spectacles',
      ),
      isFalse,
    );
    expect(await provider.archiverCategorie(contexte, categorie: categorie),
        isFalse);
    expect(await provider.ajouterBudget(contexte, budget: budget), isFalse);
    expect(await provider.archiverBudget(contexte, budget: budget), isFalse);

    expect(dao.addedCategories, isEmpty);
    expect(dao.updatedCategories, isEmpty);
    expect(dao.addedBudgets, isEmpty);
    expect(dao.updatedBudgets, isEmpty);

    final daoOK = DaoEnEchec(const {});
    addTearDown(daoOK.close);
    final providerOK = DatabaseProvider(database: daoOK);
    final BuildContext contexteOK = await pomperContexte(tester, providerOK);

    expect(
      await providerOK.ajouterCategorie(contexteOK, categorie: categorie),
      isTrue,
    );
    expect(
      await providerOK.renommerCategorie(
        contexteOK,
        categorie: categorie,
        nouveauNom: 'Spectacles',
      ),
      isTrue,
    );
    expect(await providerOK.archiverCategorie(contexteOK, categorie: categorie),
        isTrue);
    expect(await providerOK.ajouterBudget(contexteOK, budget: budget), isTrue);
    expect(await providerOK.archiverBudget(contexteOK, budget: budget), isTrue);
  });

  testWidgets('un modèle d’état vide en échec n’est pas mémorisé',
      (tester) async {
    final dao = DaoEnEchec(const {'parametre'});
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    final BuildContext contexte = await pomperContexte(tester, provider);
    final ModeleEtatVide modeleInitial = provider.modeleEtatVide;
    final ModeleEtatVide nouveau =
        modeleInitial.appliquerPreset(PresetEtatVide.encourageant);

    final bool reussi = await provider.enregistrerModeleEtatVide(
      contexte,
      modele: nouveau,
    );

    expect(reussi, isFalse);
    expect(provider.modeleEtatVide.titre, modeleInitial.titre);
    expect(dao.parametres, isEmpty);

    final daoOK = DaoEnEchec(const {});
    addTearDown(daoOK.close);
    final providerOK = DatabaseProvider(database: daoOK);
    final BuildContext contexteOK = await pomperContexte(tester, providerOK);
    expect(
      await providerOK.enregistrerModeleEtatVide(contexteOK, modele: nouveau),
      isTrue,
    );
    expect(providerOK.modeleEtatVide.titre, nouveau.titre);
  });

  testWidgets('« Autre » ne peut pas être renommé', (tester) async {
    final dao = DaoEnEchec(const {});
    addTearDown(dao.close);
    final provider = DatabaseProvider(database: dao);
    final BuildContext contexte = await pomperContexte(tester, provider);
    final Categorie autre = Categorie(id: 1, nom: 'Autre', type: 'Depense');

    final bool reussi = await provider.renommerCategorie(
      contexte,
      categorie: autre,
      nouveauNom: 'Divers',
    );

    expect(reussi, isFalse);
    expect(dao.updatedCategories, isEmpty);
  });
}
