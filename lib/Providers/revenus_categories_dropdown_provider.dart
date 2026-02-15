import 'package:flutter/material.dart';

class RevenusCategoriesDropdownProvider extends ChangeNotifier {
  String categorie = "salaire";
  void changerCategorie(String nouvelleCategorie) {
    categorie = nouvelleCategorie;
    notifyListeners();
  }
}
