import 'package:flutter/material.dart';

class RevenusCategoriesDropdownProvider extends ChangeNotifier {
  String categorie = "Salaire";
  void changerCategorie(String nouvelleCategorie) {
    categorie = nouvelleCategorie;

    notifyListeners();
  }
}
