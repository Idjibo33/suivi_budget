import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class UtilisateurPreferences {
  String key = "Infos Utilisateur";

  //Enregistrer le nom de l'utilisateur
  Future enregistrerNom(List<String> infos) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    /*  await prefs.setString(key, nouveauNom); */
    await prefs.setStringList(key, infos);
  }

  //Charger le nom de l'utilisateur
  Future<List<String>?> lireNom() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? resultat = prefs.getStringList(key);
    return resultat;
  }
}
