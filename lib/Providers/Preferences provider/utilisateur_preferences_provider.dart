import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Preferences/utilisateur_preferences.dart';

class UtilisateurPreferencesProvider extends ChangeNotifier {
  final UtilisateurPreferences _utilisateurPreferences =
      UtilisateurPreferences();

  String nom = "Non définit";
  // Charger le nom de l'utilisateur
  Future loadInfos() async {
    return await _utilisateurPreferences.readDataOnce();
  }

  // Enregistrer le nom de l'utilisateur
  Future saveInfos({required List<String> infos}) async {
    return await _utilisateurPreferences.createData(infos);
  }
}
