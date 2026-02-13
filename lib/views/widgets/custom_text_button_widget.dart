import 'package:flutter/material.dart';

class CustomTextButtonWidget extends StatelessWidget {
  final String texte;
  final VoidCallback action;
  final bool chargement;
  const CustomTextButtonWidget({
    super.key,
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
        child: chargement ? Text("Patientez") : Text(texte),
      ),
    );
  }
}
