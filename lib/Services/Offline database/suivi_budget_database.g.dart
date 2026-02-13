// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suivi_budget_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $SuiviBudgetDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $SuiviBudgetDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $SuiviBudgetDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<SuiviBudgetDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorSuiviBudgetDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $SuiviBudgetDatabaseBuilderContract databaseBuilder(String name) =>
      _$SuiviBudgetDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $SuiviBudgetDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$SuiviBudgetDatabaseBuilder(null);
}

class _$SuiviBudgetDatabaseBuilder
    implements $SuiviBudgetDatabaseBuilderContract {
  _$SuiviBudgetDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $SuiviBudgetDatabaseBuilderContract addMigrations(
      List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $SuiviBudgetDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<SuiviBudgetDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SuiviBudgetDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SuiviBudgetDatabase extends SuiviBudgetDatabase {
  _$SuiviBudgetDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TransactionDao? _transactionDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
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
            'CREATE TABLE IF NOT EXISTS `transaction_table` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `montant` INTEGER NOT NULL, `category` TEXT NOT NULL, `date` TEXT NOT NULL, `type` INTEGER NOT NULL)');

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
  )   : _queryAdapter = QueryAdapter(database),
        _transactionInsertionAdapter = InsertionAdapter(
            database,
            'transaction_table',
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'montant': item.montant,
                  'category': item.category,
                  'date': item.date,
                  'type': item.type.index
                }),
        _transactionUpdateAdapter = UpdateAdapter(
            database,
            'transaction_table',
            ['id'],
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'montant': item.montant,
                  'category': item.category,
                  'date': item.date,
                  'type': item.type.index
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Transaction> _transactionInsertionAdapter;

  final UpdateAdapter<Transaction> _transactionUpdateAdapter;

  @override
  Future<List<Transaction>> toutesLesTransactions() async {
    return _queryAdapter.queryList('SELECT * FROM transaction_table',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as int?,
            montant: row['montant'] as int,
            category: row['category'] as String,
            type: TypeTransaction.values[row['type'] as int],
            date: row['date'] as String));
  }

  @override
  Future<void> supprimerTransactionParId(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM transaction WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> ajouterTransaction(Transaction transaction) async {
    await _transactionInsertionAdapter.insert(
        transaction, OnConflictStrategy.ignore);
  }

  @override
  Future<void> misAJourtransaction(Transaction transaction) async {
    await _transactionUpdateAdapter.update(
        transaction, OnConflictStrategy.replace);
  }
}
