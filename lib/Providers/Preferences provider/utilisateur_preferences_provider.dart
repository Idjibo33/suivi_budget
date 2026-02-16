import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Preferences/utilisateur_preferences.dart';

class UtilisateurPreferencesProvider extends ChangeNotifier {
  final UtilisateurPreferences _utilisateurPreferences =
      UtilisateurPreferences();
  String? _nom;
  String? get nom => _nom;
  String? _prenom;
  String? get prenom => _prenom;
  String? _email;
  String? get email => _email;

  // Charger le nom de l'utilisateur
  Future chargerNom() async {
    List<String>? resutat = await _utilisateurPreferences.lireNom();
    _nom = resutat?.elementAt(0);
    print(_nom);
    _prenom = resutat?.elementAt(1);
    print(_prenom);
    _email = resutat?.elementAt(2);
    print(_email);
    notifyListeners();
  }

  // Enregistrer le nom de l'utilisateur
  void enregistrerNom({required List<String> infos}) async {
    await _utilisateurPreferences.enregistrerNom(infos);
    chargerNom();
    notifyListeners();
  }
}
