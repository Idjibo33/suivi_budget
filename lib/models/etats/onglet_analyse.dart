import 'package:flutter/material.dart';

/// Onglets de la page Budgets & analyses sur mobile.
///
/// Un seul onglet est affiché à la fois pour éviter une page trop longue.
enum OngletAnalyse {
  enveloppes('Enveloppes', Icons.account_balance_wallet_outlined),
  repartition('Répartition', Icons.pie_chart_outline),
  transactions('Transactions', Icons.receipt_long_outlined),
  personnalisation('Personnalisation', Icons.tune_outlined);

  const OngletAnalyse(this.libelle, this.icone);

  final String libelle;
  final IconData icone;

  /// Transition nommée depuis l'index d'un [TabBar] : toujours un état valide.
  static OngletAnalyse depuisIndex(int index) => index < 0
      ? OngletAnalyse.enveloppes
      : index >= values.length
      ? OngletAnalyse.personnalisation
      : values[index];
}
