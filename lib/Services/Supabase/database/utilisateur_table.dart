import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/utilisateur.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UtilisateurTable implements Databaseervices<Utilisateur> {
  final _supabase = Supabase.instance.client;
  final String utilisateurTable = "utilisateurs";
  @override
  Future<void> createData(Utilisateur item) {
    final data = {'nom': item.nom, 'prenom': item.prenom, 'email': item.email};
    return _supabase.from(utilisateurTable).insert(data);
  }

  @override
  Future<dynamic> deleteData(String id) {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Future<Utilisateur> readDataOnce() {
    return _supabase
        .from(utilisateurTable)
        .select()
        .single()
        .withConverter((data) => Utilisateur.fromMap(data));
  }

  @override
  Future<dynamic> updateData(String id, Utilisateur item) {
    // TODO: implement updateData
    throw UnimplementedError();
  }

  @override
  Stream<dynamic> readData() {
    // TODO: implement readData
    throw UnimplementedError();
  }
}
