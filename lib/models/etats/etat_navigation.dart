import 'package:flutter/material.dart';

/// Destination disponible dans la navigation responsive.
enum EtatNavigation {
  accueil('Accueil', Icons.home_outlined),
  budgets('Budgets', Icons.pie_chart_outline),
  ajouter('Ajouter', Icons.add_circle_outline),
  profil('Profil', Icons.person_outline);

  const EtatNavigation(this.libelle, this.icone);

  final String libelle;
  final IconData icone;

  /// Onglets de la barre mobile : « Ajouter » reste porté par le FAB.
  static const List<EtatNavigation> destinationsMobile = [
    accueil,
    budgets,
    profil,
  ];

  /// Convertit l'index d'une `NavigationRail` en destination explicite.
  static EtatNavigation depuisIndex(int index) => switch (index) {
    0 => accueil,
    1 => budgets,
    2 => ajouter,
    3 => profil,
    _ => accueil,
  };

  /// Convertit l'index d'une `NavigationBar` mobile en destination explicite.
  static EtatNavigation depuisIndexMobile(int index) => switch (index) {
    0 => accueil,
    1 => budgets,
    2 => profil,
    _ => accueil,
  };

  /// Index de l'onglet mobile : « Ajouter » n'a pas d'onglet et ramène donc
  /// à l'accueil.
  int get indexMobile => switch (this) {
    accueil => 0,
    budgets => 1,
    ajouter => 0,
    profil => 2,
  };
}
