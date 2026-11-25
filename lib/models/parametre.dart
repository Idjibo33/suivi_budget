import 'package:floor/floor.dart';

/// Paramètre local unique, stocké en JSON (`clé` → `valeur`).
@Entity(tableName: 'parametres_table')
class Parametre {
  Parametre({required this.cle, required this.valeur});

  @primaryKey
  @ColumnInfo(name: 'cle')
  final String cle;

  @ColumnInfo(name: 'valeur')
  final String valeur;
}
