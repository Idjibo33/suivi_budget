import 'package:floor/floor.dart';
import 'transaction.dart';
import 'transaction_dao.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:suivi_budget/constants.dart';
part 'suivi_budget_database.g.dart';

@Database(version: 1, entities: [Transaction])
abstract class SuiviBudgetDatabase extends FloorDatabase {
  TransactionDao get transactionDao;

  //Initialiser la base de donnée
  static Future<SuiviBudgetDatabase> initialiser() async {
    return await $FloorSuiviBudgetDatabase
        .databaseBuilder('suiviBudget_database.db')
        .build();
  }
}
