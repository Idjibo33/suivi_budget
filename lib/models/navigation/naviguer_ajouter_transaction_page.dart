import 'package:suivi_budget/models/etats/etat_onglet_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/views/widgets/ajouter_transaction_widget.dart';

void naviguerAjouterTransactionPage(
  BuildContext context, {
  EtatOngletTransaction initial = EtatOngletTransaction.revenu,
}) {
  final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;
  Navigator.push(
    context,
    isIOS
        ? CupertinoPageRoute<void>(
            builder: (context) => AjouterTransaction(ongletInitial: initial),
          )
        : MaterialPageRoute<void>(
            builder: (context) => AjouterTransaction(ongletInitial: initial),
          ),
  );
}
