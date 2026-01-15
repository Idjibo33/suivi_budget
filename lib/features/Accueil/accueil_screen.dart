import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/features/Accueil/widgets/filtrage_choice_chip_widget.dart';
import 'package:suivi_budget/features/Accueil/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/features/Accueil/widgets/depenses_widgets.dart';
import 'package:suivi_budget/features/Onboarding/onBoarding_widget.dart';
import 'package:suivi_budget/features/Accueil/widgets/revenus_widgets.dart';
import 'package:suivi_budget/features/Accueil/widgets/solde_widget.dart';
import 'package:suivi_budget/utilisateur_provider.dart';

class AccueilScreen extends StatefulWidget {
  const AccueilScreen({super.key});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nom = context.read<UtilisateurProvider>().nom;
      if (nom == "Utilisateur") {
        return entrerInfos();
      }
    });
  }

  void entrerInfos() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => const OnboardingWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monNom = context.watch<UtilisateurProvider>().nom;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: FittedBox(
                  child: Text("Suivi budget", style: Styles.texteEnTete),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bienvenue",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    Text(monNom.toString(), style: Styles.texteTitre),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              const SoldeWidget(),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.topLeft,
                child: Text("Statistiques", style: Styles.texteTitre),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: const RevenusWidgets()),
                  Expanded(child: const DepensesWidgets()),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text("Transactions récents", style: Styles.texteTitre),
              ),
              const FiltrageChoiceChipWidget(),
              const ListTransactionsWidgets(),
            ],
          ),
        ),
      ),
    );
  }
}
