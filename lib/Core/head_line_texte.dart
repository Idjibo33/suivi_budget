import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class HeadLineTexte extends StatelessWidget {
  final Color? couleure;
  final String texte;
  const HeadLineTexte({super.key, required this.texte, this.couleure});

  @override
  Widget build(BuildContext context) {
    return Text(texte, style: texteEnTete.copyWith(color: couleure));
  }
}
