// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $TransactionDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $TransactionDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $TransactionDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<TransactionDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorTransactionDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TransactionDatabaseBuilderContract databaseBuilder(String name) =>
      _$TransactionDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $TransactionDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$TransactionDatabaseBuilder(null);
}

class _$TransactionDatabaseBuilder
    implements $TransactionDatabaseBuilderContract {
  _$TransactionDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $TransactionDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $TransactionDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<TransactionDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$TransactionDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$TransactionDatabase extends TransactionDatabase {
  _$TransactionDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TransactionDao? _transactionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transactions_table` (`id` INTEGER, `montant` INTEGER NOT NULL, `categorie_id` INTEGER NOT NULL, `budget_id` INTEGER, `description` TEXT NOT NULL, `date` TEXT NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL, FOREIGN KEY (`categorie_id`) REFERENCES `categories_table` (`id`) ON UPDATE NO ACTION ON DELETE RESTRICT, FOREIGN KEY (`budget_id`) REFERENCES `budgets_table` (`id`) ON UPDATE NO ACTION ON DELETE RESTRICT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `budgets_table` (`id` INTEGER, `nom` TEXT NOT NULL, `alloue` INTEGER NOT NULL, `type_periode` TEXT NOT NULL, `date_debut` TEXT, `date_fin` TEXT, `icone` TEXT NOT NULL, `motif` TEXT NOT NULL, `archive` INTEGER NOT NULL, `depassement_autorise` INTEGER NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories_table` (`id` INTEGER, `nom` TEXT NOT NULL, `type` TEXT NOT NULL, `famille` TEXT NOT NULL, `icone` TEXT NOT NULL, `motif` TEXT NOT NULL, `personnalisee` INTEGER NOT NULL, `archive` INTEGER NOT NULL, `created_at` TEXT NOT NULL, `updated_at` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `parametres_table` (`cle` TEXT NOT NULL, `valeur` TEXT NOT NULL, PRIMARY KEY (`cle`))');

        await database.execute(
            'CREATE VIEW IF NOT EXISTS `transactions_affichees` AS   SELECT t.id AS id,\n         t.montant AS montant,\n         c.nom AS category,\n         c.type AS type,\n         t.description AS description,\n         t.date AS date,\n         t.categorie_id AS categorieId,\n         t.budget_id AS budgetId,\n         t.created_at AS createdAt,\n         t.updated_at AS updatedAt\n  FROM transactions_table AS t\n  INNER JOIN categories_table AS c ON t.categorie_id = c.id\n');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _transactionEntityInsertionAdapter = InsertionAdapter(
            database,
            'transactions_table',
            (TransactionEntity item) => <String, Object?>{
                  'id': item.id,
                  'montant': item.montant,
                  'categorie_id': item.categorieId,
                  'budget_id': item.budgetId,
                  'description': item.description,
                  'date': item.date,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _categorieInsertionAdapter = InsertionAdapter(
            database,
            'categories_table',
            (Categorie item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'type': item.type,
                  'famille': item.famille,
                  'icone': item.icone,
                  'motif': item.motif,
                  'personnalisee': item.personnalisee ? 1 : 0,
                  'archive': item.archive ? 1 : 0,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _budgetInsertionAdapter = InsertionAdapter(
            database,
            'budgets_table',
            (Budget item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'alloue': item.alloue,
                  'type_periode': item.typePeriode,
                  'date_debut': item.dateDebut,
                  'date_fin': item.dateFin,
                  'icone': item.icone,
                  'motif': item.motif,
                  'archive': item.archive ? 1 : 0,
                  'depassement_autorise': item.depassementAutorise ? 1 : 0,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _transactionEntityUpdateAdapter = UpdateAdapter(
            database,
            'transactions_table',
            ['id'],
            (TransactionEntity item) => <String, Object?>{
                  'id': item.id,
                  'montant': item.montant,
                  'categorie_id': item.categorieId,
                  'budget_id': item.budgetId,
                  'description': item.description,
                  'date': item.date,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _categorieUpdateAdapter = UpdateAdapter(
            database,
            'categories_table',
            ['id'],
            (Categorie item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'type': item.type,
                  'famille': item.famille,
                  'icone': item.icone,
                  'motif': item.motif,
                  'personnalisee': item.personnalisee ? 1 : 0,
                  'archive': item.archive ? 1 : 0,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener),
        _budgetUpdateAdapter = UpdateAdapter(
            database,
            'budgets_table',
            ['id'],
            (Budget item) => <String, Object?>{
                  'id': item.id,
                  'nom': item.nom,
                  'alloue': item.alloue,
                  'type_periode': item.typePeriode,
                  'date_debut': item.dateDebut,
                  'date_fin': item.dateFin,
                  'icone': item.icone,
                  'motif': item.motif,
                  'archive': item.archive ? 1 : 0,
                  'depassement_autorise': item.depassementAutorise ? 1 : 0,
                  'created_at': item.createdAt,
                  'updated_at': item.updatedAt
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionEntity> _transactionEntityInsertionAdapter;

  final InsertionAdapter<Categorie> _categorieInsertionAdapter;

  final InsertionAdapter<Budget> _budgetInsertionAdapter;

  final UpdateAdapter<TransactionEntity> _transactionEntityUpdateAdapter;

  final UpdateAdapter<Categorie> _categorieUpdateAdapter;

  final UpdateAdapter<Budget> _budgetUpdateAdapter;

  @override
  Future<void> deleteTransaction(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM transactions_table WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<String?> lireParametre(String cle) async {
    return _queryAdapter.query(
        'SELECT valeur FROM parametres_table WHERE cle = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        arguments: [cle]);
  }

  @override
  Future<void> ecrireParametre(
    String cle,
    String valeur,
  ) async {
    await _queryAdapter.queryNoReturn(
        'INSERT INTO parametres_table (cle, valeur) VALUES (?1, ?2)     ON CONFLICT(cle) DO UPDATE SET valeur = excluded.valeur',
        arguments: [cle, valeur]);
  }

  @override
  Stream<List<Transaction>> getTransactions() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM transactions_affichees ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as int?,
            montant: row['montant'] as int,
            category: row['category'] as String,
            type: row['type'] as String,
            description: row['description'] as String,
            date: row['date'] as String,
            categorieId: row['categorieId'] as int,
            budgetId: row['budgetId'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?),
        queryableName: 'transactions_affichees',
        isView: true);
  }

  @override
  Stream<List<Categorie>> getCategories() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM categories_table WHERE archive = 0 ORDER BY nom ASC',
        mapper: (Map<String, Object?> row) => Categorie(
            id: row['id'] as int?,
            nom: row['nom'] as String,
            type: row['type'] as String?,
            famille: row['famille'] as String,
            icone: row['icone'] as String,
            motif: row['motif'] as String,
            personnalisee: (row['personnalisee'] as int) != 0,
            archive: (row['archive'] as int) != 0,
            createdAt: row['created_at'] as String?,
            updatedAt: row['updated_at'] as String?),
        queryableName: 'categories_table',
        isView: false);
  }

  @override
  Stream<List<Categorie>> getToutesCategories() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM categories_table ORDER BY nom ASC',
        mapper: (Map<String, Object?> row) => Categorie(
            id: row['id'] as int?,
            nom: row['nom'] as String,
            type: row['type'] as String?,
            famille: row['famille'] as String,
            icone: row['icone'] as String,
            motif: row['motif'] as String,
            personnalisee: (row['personnalisee'] as int) != 0,
            archive: (row['archive'] as int) != 0,
            createdAt: row['created_at'] as String?,
            updatedAt: row['updated_at'] as String?),
        queryableName: 'categories_table',
        isView: false);
  }

  @override
  Future<int?> nombreTransactionsCategorie(int id) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM transactions_table WHERE categorie_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Stream<List<Budget>> getBudgets() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM budgets_table WHERE archive = 0 ORDER BY nom ASC',
        mapper: (Map<String, Object?> row) => Budget(
            id: row['id'] as int?,
            nom: row['nom'] as String,
            alloue: row['alloue'] as int,
            typePeriode: row['type_periode'] as String?,
            dateDebut: row['date_debut'] as String?,
            dateFin: row['date_fin'] as String?,
            icone: row['icone'] as String,
            motif: row['motif'] as String,
            archive: (row['archive'] as int) != 0,
            depassementAutorise: (row['depassement_autorise'] as int) != 0,
            createdAt: row['created_at'] as String?,
            updatedAt: row['updated_at'] as String?),
        queryableName: 'budgets_table',
        isView: false);
  }

  @override
  Stream<List<Budget>> getToutBudgets() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM budgets_table ORDER BY nom ASC',
        mapper: (Map<String, Object?> row) => Budget(
            id: row['id'] as int?,
            nom: row['nom'] as String,
            alloue: row['alloue'] as int,
            typePeriode: row['type_periode'] as String?,
            dateDebut: row['date_debut'] as String?,
            dateFin: row['date_fin'] as String?,
            icone: row['icone'] as String,
            motif: row['motif'] as String,
            archive: (row['archive'] as int) != 0,
            depassementAutorise: (row['depassement_autorise'] as int) != 0,
            createdAt: row['created_at'] as String?,
            updatedAt: row['updated_at'] as String?),
        queryableName: 'budgets_table',
        isView: false);
  }

  @override
  Future<int?> nombreTransactionsBudget(int id) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM transactions_table WHERE budget_id = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> addTransactionEntity(TransactionEntity transaction) async {
    await _transactionEntityInsertionAdapter.insert(
        transaction, OnConflictStrategy.replace);
  }

  @override
  Future<void> addCategorie(Categorie categorie) async {
    await _categorieInsertionAdapter.insert(
        categorie, OnConflictStrategy.abort);
  }

  @override
  Future<void> addBudget(Budget budget) async {
    await _budgetInsertionAdapter.insert(budget, OnConflictStrategy.abort);
  }

  @override
  Future<void> editTransactionEntity(TransactionEntity transaction) async {
    await _transactionEntityUpdateAdapter.update(
        transaction, OnConflictStrategy.replace);
  }

  @override
  Future<void> editCategorieBrute(Categorie categorie) async {
    await _categorieUpdateAdapter.update(categorie, OnConflictStrategy.replace);
  }

  @override
  Future<void> editBudgetBrute(Budget budget) async {
    await _budgetUpdateAdapter.update(budget, OnConflictStrategy.replace);
  }
}
