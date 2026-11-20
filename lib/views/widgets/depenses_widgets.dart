import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';

class DepensesWidgets extends StatelessWidget {
  final bool chargement;
  final int totalDepenses;
  const DepensesWidgets({
    super.key,
    required this.totalDepenses,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dépenses",
          style: Styles.texteCorps.copyWith(
            color: Styles.texteSecondaire(context),
          ),
        ),
        Skeletonizer(
          enabled: chargement,
          containersColor: Styles.surfaceSecondaire(context),
          child: Text(
            FormatMontant.afficherAvecSigne(
              totalDepenses,
              estRevenu: false,
              devise: false,
            ),
            style: Styles.texteMontantCompact.copyWith(
              color: Styles.couleurDepense(context),
            ),
          ),
        ),
      ],
    );
  }
}
