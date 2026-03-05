import 'package:suivi_budget/Services/database/transaction_dao.dart';
import 'package:floor/floor.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'transaction_database.g.dart';

@Database(version: 1, entities: [Transaction])
abstract class TransactionDatabase extends FloorDatabase {
  TransactionDao get transactionDao;

  static Future<TransactionDatabase> intialize() async {
    return await $FloorTransactionDatabase
        .databaseBuilder("transaction_database")
        .build();
  }
}
