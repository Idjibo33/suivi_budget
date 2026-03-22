import 'package:flutter/material.dart';
import 'package:suivi_budget/views/Authentification/inscription_page.dart';

void naviguerInscriptionPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => InscriptionPage()),
  );
}
