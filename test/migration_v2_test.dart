import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:suivi_budget/services/database/transaction_database.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  test(
    'la migration V1 → V2 recrée les tables en conservant les transactions',
    () async {
      final repertoire = await Directory.systemTemp.createTemp('mybudget-v1-');
      addTearDown(() => repertoire.delete(recursive: true));
      final chemin = '${repertoire.path}/transaction_database';
      final database = await databaseFactory.openDatabase(
        chemin,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute(
              'CREATE TABLE transactions_table (id INTEGER PRIMARY KEY, montant INTEGER NOT NULL, category TEXT NOT NULL, description TEXT NOT NULL, type TEXT NOT NULL, date TEXT NOT NULL)',
            );
            await db.insert('transactions_table', {
              'id': 1,
              'montant': 500,
              'category': 'Salaire',
              'description': 'V1',
              'type': 'Revenu',
              'date': '2026-09-01 08:00:00.000',
            });
          },
        ),
      );

      await database.close();
      final floor = await $FloorTransactionDatabase
          .databaseBuilder(chemin)
          .addMigrations([migrationV1VersV2, migrationV2VersV3])
          .build();
      addTearDown(floor.close);
      final baseMigree = floor.database;
      final historiques = await floor.transactionDao.getTransactions().first;
      expect(historiques.single.date, '2026-09-01 08:00:00.000');

      final List<Map<String, Object?>> tables = await baseMigree.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'table'",
      );
      final List<String> noms = tables
          .map((row) => row['name'] as String)
          .toList();

      expect(noms, contains('budgets_table'));
      expect(noms, contains('categories_table'));
      expect(noms, contains('transactions_table'));

      final List<Map<String, Object?>> vues = await baseMigree.rawQuery(
        "SELECT name FROM sqlite_master WHERE type = 'view'",
      );
      expect(
        vues.map((row) => row['name'] as String),
        contains('transactions_affichees'),
      );

      final List<Map<String, Object?>> colonnes = await baseMigree.rawQuery(
        'PRAGMA table_info(transactions_table)',
      );
      final List<String> nomsColonnes = colonnes
          .map((row) => row['name'] as String)
          .toList();

      expect(nomsColonnes, contains('categorie_id'));
      expect(nomsColonnes, contains('budget_id'));
      expect(nomsColonnes, contains('created_at'));
      expect(nomsColonnes, contains('updated_at'));
      expect(nomsColonnes, isNot(contains('category')));
      expect(nomsColonnes, isNot(contains('type')));

      final List<Map<String, Object?>> restantes = await baseMigree.rawQuery(
        'SELECT * FROM transactions_table',
      );
      expect(restantes.single['id'], 1);
      expect(restantes.single['montant'], 500);
      expect(restantes.single['budget_id'], isNull);
      final affichees = await baseMigree.query('transactions_affichees');
      expect(affichees.single['type'], 'Revenu');
      expect(affichees.single['description'], 'V1');
    },
  );

  test(
    'la mise à jour des catégories préserve les choix et les opérations',
    () async {
      final dossier = await Directory.systemTemp.createTemp('mybudget-v2-');
      addTearDown(() => dossier.delete(recursive: true));
      final chemin = '${dossier.path}/transaction_database';
      final ancienne = await databaseFactory.openDatabase(
        chemin,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: (db, _) async {
            await db.execute(
              'CREATE TABLE transactions_table (id INTEGER PRIMARY KEY, montant INTEGER NOT NULL, category TEXT NOT NULL, description TEXT NOT NULL, type TEXT NOT NULL, date TEXT NOT NULL)',
            );
            await db.insert('transactions_table', {
              'id': 1,
              'montant': 500,
              'category': 'Salaire',
              'description': 'Paie',
              'type': 'Revenu',
              'date': '2026-09-01 08:00:00.000',
            });
            await migrationV1VersV2.migrate(db);
            await db.delete(
              'categories_table',
              where: 'nom = ?',
              whereArgs: ['Restaurants'],
            );
            await db.update(
              'categories_table',
              {'nom': 'Paie mensuelle', 'personnalisee': 1},
              where: 'nom = ?',
              whereArgs: ['Salaire'],
            );
            await db.update(
              'categories_table',
              {'archive': 1},
              where: 'nom = ?',
              whereArgs: ['Factures'],
            );
          },
        ),
      );
      await ancienne.close();

      final base = await $FloorTransactionDatabase
          .databaseBuilder(chemin)
          .addMigrations([migrationV2VersV3])
          .build();
      addTearDown(base.close);
      final categories = await base.transactionDao.getToutesCategories().first;
      expect(
        categories.where((c) => c.nom == 'Factures').single.archive,
        isTrue,
      );
      expect(
        categories.where((c) => c.nom == 'Restaurants').single.type,
        'Depense',
      );
      expect(
        categories.where((c) => c.nom == 'Paie mensuelle').single.personnalisee,
        isTrue,
      );
      final transaction =
          (await base.transactionDao.getTransactions().first).single;
      expect(transaction.category, 'Paie mensuelle');
      expect(transaction.montant, 500);
    },
  );
}
