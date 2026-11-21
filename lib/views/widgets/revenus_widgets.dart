import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';

class RevenusWidgets extends StatelessWidget {
  final bool chargement;
  final int totalRevenus;
  const RevenusWidgets({
    super.key,
    required this.totalRevenus,
    required this.chargement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Revenus",
          style: Styles.texteCorps.copyWith(
            color: Styles.texteSecondaire(context),
          ),
        ),
        Skeletonizer(
          enabled: chargement,
          containersColor: Styles.surfaceSecondaire(context),
          child: Text(
            FormatMontant.afficherAvecSigne(
              totalRevenus,
              estRevenu: true,
              devise: false,
            ),
            style: Styles.texteMontantCompact.copyWith(
              color: Styles.couleurRevenu(context),
            ),
          ),
        ),
      ],
    );
  }
}
