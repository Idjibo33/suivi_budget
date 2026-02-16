import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RevenusCategoriesProvider extends ChangeNotifier {
  String? categorie;
  void changerCategorie(String nouvelleCategorie) {
    HapticFeedback.selectionClick();
    categorie = nouvelleCategorie;
    notifyListeners();
  }
}
