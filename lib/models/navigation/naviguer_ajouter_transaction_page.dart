import 'package:flutter/material.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

void naviguerAjouterTransactionPage(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => AjouterTransaction()),
  );
}
