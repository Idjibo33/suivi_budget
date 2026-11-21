import 'package:flutter/material.dart';

/// Destination disponible dans la navigation latérale responsive.
enum EtatNavigation {
  accueil('Accueil', Icons.home_outlined),
  ajouter('Ajouter', Icons.add_circle_outline),
  profil('Profil', Icons.person_outline);

  const EtatNavigation(this.libelle, this.icone);

  final String libelle;
  final IconData icone;

  /// Convertit l'index d'une `NavigationRail` en destination explicite.
  static EtatNavigation depuisIndex(int index) => switch (index) {
        0 => accueil,
        1 => ajouter,
        2 => profil,
        _ => accueil,
      };
}
