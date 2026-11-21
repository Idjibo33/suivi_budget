import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

/// Marque MyBudget : glyphe blanc sur un disque teal.
///
/// Le fichier est généré par `scripts/generate_brand_assets.py` et embarqué
/// dans l'application : aucun téléchargement au runtime, y compris sur le web.
class CustomLogoWidget extends StatelessWidget {
  final double padding;
  final double size;

  const CustomLogoWidget({
    super.key,
    required this.padding,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppCouleurs.teal,
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Image.asset(
          'assets/images/logo_foreground.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          excludeFromSemantics: true,
        ),
      ),
    );
  }
}
