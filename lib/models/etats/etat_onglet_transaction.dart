import 'package:flutter/material.dart';

/// Onglet du formulaire d'ajout : revenu ou dépense.
///
/// Remplace un `TabController` implicite par un état explicite : le changement
/// d'apparence peut reconstruire l'écran sans toucher à un contrôleur
/// d'animation (ce qui provoquait une assertion `setState()` pendant le build).
enum EtatOngletTransaction { revenu, depense }

extension EtatOngletTransactionX on EtatOngletTransaction {
  String get libelle => switch (this) {
    EtatOngletTransaction.revenu => 'Revenu',
    EtatOngletTransaction.depense => 'Dépense',
  };

  IconData get icone => switch (this) {
    EtatOngletTransaction.revenu => Icons.add_circle_outline,
    EtatOngletTransaction.depense => Icons.remove_circle_outline,
  };
}
