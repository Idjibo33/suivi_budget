import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/body_texte.dart';
import 'package:suivi_budget/Core/titre_texte.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/floating_button.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/solde_widget.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ProfilScreen(),
        ),
      ),
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
                        const CustomLogoWidget(padding: 7.0, size: 25),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BodyTexte(texte: "Bienvenue"),
                            const TitreTexte(texte: "Utilisateur"),
                          ],
                        ),
                      ],
                    ),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
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
