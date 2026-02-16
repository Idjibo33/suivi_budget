import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DepensesCategoriesProvider extends ChangeNotifier {
  // La valeur du dropdown de la catégorie Revenus
  String categorie = "Courses";
  void changerCategorie(String nouvelleCategorie) {
    HapticFeedback.selectionClick();
    categorie = nouvelleCategorie;
    notifyListeners();
  }
}
