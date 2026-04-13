import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Core/widgets/body_texte.dart';
import 'package:suivi_budget/Core/widgets/head_line_texte.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/depenses_widgets.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/revenus_widgets.dart';

class SoldeWidget extends StatelessWidget {
  const SoldeWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: LinearGradient(
            begin: AlignmentGeometry.topLeft,
            end: AlignmentGeometry.bottomRight,
            colors: gradient1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            spacing: 12,
            children: [
              const BodyTexte(texte: "Solde total"),
              HeadLineTexte(
                texte: "${database.soldeTotal()} F CFA",
                couleure: Colors.white,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RevenusWidgets(
                    totalRevenus: database.totalRevenus(),
                    chargement: database.chargement,
                  ),
                  DepensesWidgets(
                    totalDepenses: database.totalDepenses(),
                    chargement: database.chargement,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
