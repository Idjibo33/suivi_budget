import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_budget/models/helpers.dart';

class UtilisateurPreferences implements Databaseervices<List<String>> {
  String key = "Infos Utilisateur";

  //Charger les informations de l'utilisateur
  Future<List<String>?> readInfos() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? resultat = prefs.getStringList(key);
    return resultat;
  }

  @override
  Future createData(List<String> infos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, infos);
  }

  @override
  Future<List<String>?> readDataOnce() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? resultat = prefs.getStringList(key);
    return resultat;
  }

  @override
  Future deleteData(String id) {
    // TODO: implement deleteData
    throw UnimplementedError();
  }

  @override
  Stream<dynamic> readData() {
    // TODO: implement readData
    throw UnimplementedError();
  }

  @override
  Future updateData(String id, item) {
    // TODO: implement updateData
    throw UnimplementedError();
  }
}
