import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';

class TitreTexte extends StatelessWidget {
  final Color? couleure;
  final String texte;
  const TitreTexte({super.key, required this.texte, this.couleure});

  @override
  Widget build(BuildContext context) {
    return Text(texte, style: texteTitre.copyWith(color: couleure));
  }
}
