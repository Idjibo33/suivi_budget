import 'package:flutter/material.dart';

class CustomFilledButtonWidget extends StatelessWidget {
  final Color? couleur;
  final String texte;
  final VoidCallback action;
  final bool chargement;
  const CustomFilledButtonWidget({
    super.key,
    required this.texte,
    required this.action,
    required this.chargement,
    this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        style: couleur == null
            ? null
            : FilledButton.styleFrom(backgroundColor: couleur),
        onPressed: chargement ? null : action,
        child: Text(chargement ? "Patientez" : texte),
      ),
    );
  }
}
