import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/widgets/body_texte.dart';
import 'package:suivi_budget/Core/widgets/titre_texte.dart';
import 'package:suivi_budget/Features/settings/presentation/screens/settings_screen.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/Core/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/solde_widget.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 8,
                      children: [
                        const CustomLogoWidget(size: 50),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BodyTexte(texte: "Bienvenue"),
                            const TitreTexte(texte: "Utilisateur"),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SettingsScreen(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: couleurbgSecondaire,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.settings),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SoldeWidget(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitreTexte(texte: "Transactions récents"),
                  BodyTexte(texte: "Voir tout"),
                ],
              ),
              Expanded(child: ListTransactionsWidgets()),
            ],
          ),
        ),
      ),
    );
  }
}
