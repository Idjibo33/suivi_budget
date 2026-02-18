import 'package:flutter/material.dart';

class ModifierTransactionViewProvider extends ChangeNotifier {
  bool showview = false;
  void changer() {
    showview = !showview;
    notifyListeners();
  }
}
