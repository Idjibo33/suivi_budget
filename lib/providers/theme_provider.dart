import 'package:flutter/material.dart';
import 'package:suivi_budget/models/etats/etat_theme.dart';

/// Préférence d'apparence partagée entre la page de profil et [MaterialApp].
class ThemeProvider extends ChangeNotifier {
  ModeTheme _mode = ModeTheme.systeme;

  ModeTheme get mode => _mode;
  ThemeMode get themeMode => _mode.themeMode;

  /// Transition nommée : un choix identique ne notifie pas les auditeurs.
  void choisir(ModeTheme nouveauMode) {
    if (nouveauMode == _mode) {
      return;
    }
    _mode = nouveauMode;
    notifyListeners();
  }
}
