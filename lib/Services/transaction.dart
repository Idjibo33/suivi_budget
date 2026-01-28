import 'package:floor/floor.dart';
import 'package:suivi_budget/constants.dart';

@Entity(tableName: 'transaction_table')
class Transaction {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: "montant")
  final int montant;

  @ColumnInfo(name: "category")
  final String category;

  @ColumnInfo(name: "date")
  final String date;

  @ColumnInfo(name: "type")
  final TypeTransaction type;

  Transaction({
    this.id,
    required this.montant,
    required this.category,
    required this.type,
    required this.date,
  });
}
