import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/providers/database_provider.dart';

import 'fixtures/fakes.dart';

void main() {
  late FakeTransactionDao dao;
  late DatabaseProvider provider;

  setUp(() {
    dao = FakeTransactionDao();
    provider = DatabaseProvider(database: dao)..listenTransactions();
  });

  tearDown(() => dao.close());

  test('état initial : liste en chargement', () {
    expect(provider.listChargement, isTrue);
    expect(provider.transactionsListe, isEmpty);
    expect(provider.listErreur, isNull);
  });

  test(
    'émission de transactions : fin du chargement et totaux à jour',
    () async {
      await dao.emit([
        buildTransaction(montant: 1000, type: 'Revenu'),
        buildTransaction(montant: 400, type: 'Depense', category: 'Courses'),
      ]);

      expect(provider.listChargement, isFalse);
      expect(provider.listErreur, isNull);
      expect(provider.transactionsListe, hasLength(2));
      expect(provider.totalRevenus(), 1000);
      expect(provider.totalDepenses(), 400);
      expect(provider.soldeTotal(), 600);
    },
  );

  test('le solde global est indépendant des plafonds', () async {
    provider.listenDonneesV2();
    await dao.emitBudgets([
      Budget(id: 1, nom: 'Courses', alloue: 50000),
      Budget(id: 2, nom: 'Ancienne', alloue: 70000, archive: true),
    ]);
    await dao.emit([
      buildTransaction(montant: 100000, type: 'Revenu'),
      buildTransaction(montant: 12000, type: 'Depense'),
    ]);

    expect(provider.soldeTotal(), 88000);
  });

  test('erreur du flux : fin du chargement et message convivial', () async {
    await dao.emitError(Exception('db error'));

    expect(provider.listChargement, isFalse);
    expect(provider.listErreur, 'Impossible de charger les transactions');
  });

  test('erreur du flux : les totaux gardent la dernière liste reçue', () async {
    await dao.emit([buildTransaction(montant: 1000, type: 'Revenu')]);
    await dao.emitError(Exception('db error'));

    expect(provider.listErreur, 'Impossible de charger les transactions');
    expect(provider.soldeTotal(), 1000);
  });

  test(
    'liste vide après émission : plus de chargement, pas d\'erreur',
    () async {
      await dao.emit([]);

      expect(provider.listChargement, isFalse);
      expect(provider.transactionsListe, isEmpty);
      expect(provider.listErreur, isNull);
    },
  );

  testWidgets('désarchiver une enveloppe écrit une copie active et réussit', (
    tester,
  ) async {
    final budget = Budget(
      id: 3,
      nom: 'Ancienne',
      alloue: 1000,
      archive: true,
      createdAt: '2026-01-01T00:00:00.000',
      updatedAt: '2026-01-01T00:00:00.000',
    );
    final key = GlobalKey();
    await tester.pumpWidget(MaterialApp(home: Container(key: key)));
    final BuildContext context = key.currentContext!;

    final bool reussi = await provider.desarchiverBudget(
      context,
      budget: budget,
    );

    expect(reussi, isTrue);
    expect(dao.updatedBudgets, hasLength(1));
    expect(dao.updatedBudgets.single.id, budget.id);
    expect(dao.updatedBudgets.single.archive, isFalse);
    expect(dao.updatedBudgets.single.createdAt, budget.createdAt);
    expect(dao.updatedBudgets.single.updatedAt, isNot(budget.updatedAt));
  });
}
