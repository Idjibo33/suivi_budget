import 'package:flutter/material.dart';

/// Préférence d'apparence, modelée explicitement plutôt que par des booléens.
enum ModeTheme { systeme, clair, sombre }

extension ModeThemeX on ModeTheme {
  ThemeMode get themeMode => switch (this) {
    ModeTheme.systeme => ThemeMode.system,
    ModeTheme.clair => ThemeMode.light,
    ModeTheme.sombre => ThemeMode.dark,
  };

  String get libelle => switch (this) {
    ModeTheme.systeme => 'Système',
    ModeTheme.clair => 'Clair',
    ModeTheme.sombre => 'Sombre',
  };

  IconData get icone => switch (this) {
    ModeTheme.systeme => Icons.brightness_auto,
    ModeTheme.clair => Icons.light_mode_outlined,
    ModeTheme.sombre => Icons.dark_mode_outlined,
  };
}
