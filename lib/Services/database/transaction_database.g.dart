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
            'CREATE TABLE IF NOT EXISTS `transactions_table` (`id` INTEGER, `montant` INTEGER NOT NULL, `category` TEXT NOT NULL, `description` TEXT NOT NULL, `type` TEXT NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`id`))');

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
        _transactionInsertionAdapter = InsertionAdapter(
            database,
            'transactions_table',
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'montant': item.montant,
                  'category': item.category,
                  'description': item.description,
                  'type': item.type,
                  'date': item.date
                },
            changeListener),
        _transactionUpdateAdapter = UpdateAdapter(
            database,
            'transactions_table',
            ['id'],
            (Transaction item) => <String, Object?>{
                  'id': item.id,
                  'montant': item.montant,
                  'category': item.category,
                  'description': item.description,
                  'type': item.type,
                  'date': item.date
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Transaction> _transactionInsertionAdapter;

  final UpdateAdapter<Transaction> _transactionUpdateAdapter;

  @override
  Future<void> deleteTransaction(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM transactions_table WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Stream<List<Transaction>> getTransactions() {
    return _queryAdapter.queryListStream('SELECT * FROM transactions_table',
        mapper: (Map<String, Object?> row) => Transaction(
            id: row['id'] as int?,
            montant: row['montant'] as int,
            category: row['category'] as String,
            description: row['description'] as String,
            type: row['type'] as String,
            date: row['date'] as String),
        queryableName: 'transactions_table',
        isView: false);
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionInsertionAdapter.insert(
        transaction, OnConflictStrategy.ignore);
  }

  @override
  Future<void> editTransaction(Transaction transaction) async {
    await _transactionUpdateAdapter.update(
        transaction, OnConflictStrategy.replace);
  }
}
