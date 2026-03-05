import 'package:floor/floor.dart';

@Entity(tableName: "transactions_table")
class Transaction {
  @primaryKey
  final int? id;
  final int montant;
  final String category;
  final String description;
  final String type;
  final String date;
  Transaction({
    this.id,
    required this.montant,
    required this.category,
    required this.description,
    required this.type,
    required this.date,
  });
}
