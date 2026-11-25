import 'package:flutter/material.dart';

import '../etats/type_categorie.dart';

/// Sens d'une transaction porté par l'icône, jamais par une couleur de statut.
IconData iconeTypeTransaction(TypeCategorie type) => switch (type) {
      TypeCategorie.revenu => Icons.arrow_upward,
      TypeCategorie.depense => Icons.arrow_downward,
    };
