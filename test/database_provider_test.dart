import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';

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

  test('émission de transactions : fin du chargement et totaux à jour',
      () async {
    await dao.emit([
      buildTransaction(montant: 1000, type: 'Revenu'),
      buildTransaction(
        montant: 400,
        type: 'Depense',
        category: 'Courses',
      ),
    ]);

    expect(provider.listChargement, isFalse);
    expect(provider.listErreur, isNull);
    expect(provider.transactionsListe, hasLength(2));
    expect(provider.totalRevenus(), 1000);
    expect(provider.totalDepenses(), 400);
    expect(provider.soldeTotal(), 600);
  });

  test('erreur du flux : fin du chargement et message convivial', () async {
    await dao.emitError(Exception('db error'));

    expect(provider.listChargement, isFalse);
    expect(provider.listErreur, 'Impossible de charger les transactions');
  });

  test('liste vide après émission : plus de chargement, pas d\'erreur',
      () async {
    await dao.emit([]);

    expect(provider.listChargement, isFalse);
    expect(provider.transactionsListe, isEmpty);
    expect(provider.listErreur, isNull);
  });
}
