import 'package:flutter/material.dart';
import 'package:suivi_budget/preferences_repository.dart';

class UtilisateurProvider extends ChangeNotifier {
  final UtilisateurPreferences preferences = UtilisateurPreferences();
  String? _nom;
  String? get nom => _nom;

  //Charger le nom de l'utilisteur
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
