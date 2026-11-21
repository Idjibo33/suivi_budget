import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/etats/etat_theme.dart';
import 'package:suivi_budget/providers/theme_provider.dart';

void main() {
  test('le mode par défaut suit le système', () {
    final ThemeProvider provider = ThemeProvider();

    expect(provider.mode, ModeTheme.systeme);
    expect(provider.themeMode, ThemeMode.system);
  });

  test('le changement de mode notifie et mappe vers ThemeMode', () {
    final ThemeProvider provider = ThemeProvider();
    int notifications = 0;
    provider.addListener(() => notifications++);

    provider.choisir(ModeTheme.sombre);
    expect(provider.mode, ModeTheme.sombre);
    expect(provider.themeMode, ThemeMode.dark);
    expect(notifications, 1);

    provider.choisir(ModeTheme.sombre);
    expect(notifications, 1);

    provider.choisir(ModeTheme.clair);
    expect(provider.themeMode, ThemeMode.light);
    expect(notifications, 2);
  });

  test('chaque mode expose un libellé et une icône', () {
    for (final ModeTheme mode in ModeTheme.values) {
      expect(mode.libelle, isNotEmpty);
      expect(mode.icone, isNotNull);
    }
  });
}
