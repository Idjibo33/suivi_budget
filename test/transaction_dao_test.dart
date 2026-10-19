import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide Transaction;
import 'package:suivi_budget/Services/database/transaction_dao.dart';
import 'package:suivi_budget/Services/database/transaction_database.dart';
import 'package:suivi_budget/models/transaction.dart';

import 'fixtures/fakes.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late TransactionDatabase database;
  late TransactionDao dao;

  setUp(() async {
    database = await $FloorTransactionDatabase.inMemoryDatabaseBuilder()
        .build();
    dao = database.transactionDao;
  });

  tearDown(() async {
    await database.close();
  });

  test('getTransactions trie les transactions par date décroissante',
      () async {
    await dao.addTransaction(
      buildTransaction(id: 1, date: '2026-10-01 08:00:00.000'),
    );
    await dao.addTransaction(
      buildTransaction(id: 2, date: '2026-10-19 08:00:00.000'),
    );
    await dao.addTransaction(
      buildTransaction(id: 3, date: '2026-10-10 08:00:00.000'),
    );

    final List<Transaction> transactions = await dao.getTransactions().first;

    expect(
      transactions.map((Transaction transaction) => transaction.date).toList(),
      <String>[
        '2026-10-19 08:00:00.000',
        '2026-10-10 08:00:00.000',
        '2026-10-01 08:00:00.000',
      ],
    );
  });
}
