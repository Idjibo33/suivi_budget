import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final Color? couleurTexte;
  final String texte;
  final VoidCallback action;
  final bool chargement;
  const CustomTextButtonWidget({
    super.key,
    this.couleurTexte,
    required this.texte,
    required this.action,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: chargement ? null : action,
        child: chargement
            ? Text("Patientez")
            : Text(texte, style: texteTitre.copyWith(color: couleurTexte)),
      ),
    );
  }
}
