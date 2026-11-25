import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/categories_par_defaut.dart';
import 'package:suivi_budget/models/parametre.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/models/transaction_entity.dart';
import 'package:suivi_budget/services/database/transaction_dao.dart';

part 'transaction_database.g.dart';

/// Conserve les transactions historiques et leurs catégories.
final Migration migrationV1VersV2 = Migration(1, 2, (database) async {
  await database.execute(
    'ALTER TABLE transactions_table RENAME TO transactions_v1',
  );
  await _creerTables(database);
  final categories = <(String, String), int>{};

  for (final categorie in categoriesParDefaut) {
    categories[(categorie.type, categorie.nom)] = await _insererCategorie(
      database,
      categorie,
    );
  }
  final horodatageMigration = DateTime.now().toIso8601String();
  for (final ligne in await database.query('transactions_v1')) {
    final type = ligne['type'] as String;
    final nom = ligne['category'] as String;
    final cle = (type, nom);
    final categorieId = categories[cle] ??= await _insererCategorie(
      database,
      Categorie(nom: nom, type: type, personnalisee: true),
    );
    await database.insert('transactions_table', {
      'id': ligne['id'],
      'montant': ligne['montant'],
      'categorie_id': categorieId,
      'description': ligne['description'],
      'date': ligne['date'],
      'created_at': horodatageMigration,
      'updated_at': horodatageMigration,
    });
  }
  await database.execute('DROP TABLE transactions_v1');
});

/// Ajoute une seule fois les nouvelles suggestions, sans modifier les catégories existantes.
final Migration migrationV2VersV3 = Migration(2, 3, (database) async {
  final existantes = await database.query(
    'categories_table',
    columns: ['type', 'nom'],
  );
  final cles = {
    for (final ligne in existantes)
      (ligne['type'], _nomCategorieNormalise(ligne['nom'] as String)),
  };
  for (final categorie in nouvellesCategoriesParDefaut) {
    if (cles.add((categorie.type, _nomCategorieNormalise(categorie.nom)))) {
      await _insererCategorie(database, categorie);
    }
  }
});

String _nomCategorieNormalise(String nom) => nom.trim().toLowerCase();

Future<int> _insererCategorie(sqflite.Database database, Categorie categorie) =>
    database.insert('categories_table', {
      'nom': categorie.nom,
      'type': categorie.type,
      'famille': categorie.famille,
      'icone': categorie.icone,
      'motif': categorie.motif,
      'personnalisee': categorie.personnalisee ? 1 : 0,
      'archive': 0,
      'created_at': categorie.createdAt,
      'updated_at': categorie.updatedAt,
    });

Future<void> _creerTables(sqflite.Database database) async {
  await database.execute('''
    CREATE TABLE IF NOT EXISTS budgets_table (
      id INTEGER,
      nom TEXT NOT NULL,
      alloue INTEGER NOT NULL,
      type_periode TEXT NOT NULL,
      date_debut TEXT,
      date_fin TEXT,
      icone TEXT NOT NULL,
      motif TEXT NOT NULL,
      archive INTEGER NOT NULL,
      depassement_autorise INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      PRIMARY KEY (id)
    )
  ''');
  await database.execute('''
    CREATE TABLE IF NOT EXISTS categories_table (
      id INTEGER,
      nom TEXT NOT NULL,
      type TEXT NOT NULL,
      famille TEXT NOT NULL,
      icone TEXT NOT NULL,
      motif TEXT NOT NULL,
      personnalisee INTEGER NOT NULL,
      archive INTEGER NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      PRIMARY KEY (id)
    )
  ''');
  await database.execute('''
    CREATE TABLE IF NOT EXISTS transactions_table (
      id INTEGER,
      montant INTEGER NOT NULL,
      categorie_id INTEGER NOT NULL,
      budget_id INTEGER,
      description TEXT NOT NULL,
      date TEXT NOT NULL,
      created_at TEXT NOT NULL,
      updated_at TEXT NOT NULL,
      PRIMARY KEY (id),
      FOREIGN KEY (categorie_id) REFERENCES categories_table (id) ON DELETE RESTRICT,
      FOREIGN KEY (budget_id) REFERENCES budgets_table (id) ON DELETE RESTRICT
    )
  ''');
  await database.execute('''
    CREATE TABLE IF NOT EXISTS parametres_table (
      cle TEXT PRIMARY KEY,
      valeur TEXT NOT NULL
    )
  ''');
  await database.execute('''
    CREATE VIEW IF NOT EXISTS transactions_affichees AS
    SELECT t.id AS id,
           t.montant AS montant,
           c.nom AS category,
           c.type AS type,
           t.description AS description,
           t.date AS date,
           t.categorie_id AS categorieId,
           t.budget_id AS budgetId,
           t.created_at AS createdAt,
           t.updated_at AS updatedAt
    FROM transactions_table AS t
    INNER JOIN categories_table AS c ON t.categorie_id = c.id
  ''');
}

@Database(
  version: 3,
  entities: [TransactionEntity, Budget, Categorie, Parametre],
  views: [Transaction],
)
abstract class TransactionDatabase extends FloorDatabase {
  TransactionDao get transactionDao;

  static Future<TransactionDatabase> initialize() async {
    final TransactionDatabase database = await $FloorTransactionDatabase
        .databaseBuilder('transaction_database')
        .addMigrations([migrationV1VersV2, migrationV2VersV3])
        .build();
    await _initialiserCategories(database.transactionDao);
    return database;
  }

  static Future<void> _initialiserCategories(TransactionDao dao) async {
    final List<Categorie> existantes = await dao.getToutesCategories().first;
    if (existantes.isNotEmpty) {
      return;
    }
    for (final Categorie categorie in categoriesParDefaut) {
      await dao.addCategorie(categorie);
    }
  }
}
