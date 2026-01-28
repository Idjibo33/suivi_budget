import 'package:flutter/material.dart';

class DepensesCategoriesDropdownProvider extends ChangeNotifier {
  // La valeur du dropdown de la catégorie Revenus
  String categorie = "courses";
  void changerCategorie(String nouvelleCategorie) {
    categorie = nouvelleCategorie;
    notifyListeners();
  }
}
