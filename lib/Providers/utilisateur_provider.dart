import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Preferences/utilisateur_preferences.dart';

class UtilisateurProvider extends ChangeNotifier {
  final UtilisateurPreferences preferences = UtilisateurPreferences();
  String? _nom;
  String? get nom => _nom;

  //Initialiser le nom de l'utilisteur
  Future<void> initialiserNom() async {
    _nom = await preferences.lireNom();
    notifyListeners();
  }

  //Mettre à jour le nom
  Future<void> misAJourNom(String nouveauNom) async {
    await preferences.enregistrerNom(nouveauNom);
    _nom = nouveauNom;
    notifyListeners();
  }
}
