import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Functions/deconnecter_utilisateur.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/deconnexion_services_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/depenses_widgets.dart';
import 'package:suivi_budget/views/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/views/widgets/revenus_widgets.dart';
import 'package:suivi_budget/views/widgets/solde_widget.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: ProfilScreen(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text("Suivi budget", style: Styles.texteEnTete),
                  ),
                ],
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
                    Text("Nom", style: Styles.texteTitre),
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
              Consumer<DeconnexionServicesProvider>(
                builder: (context, value, child) => CustomFilledButtonWidget(
                  texte: "Deconnecter",
                  action: () => deconnecterUtilisateur(context: context),
                  chargement: value.chargement,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Transactions récents", style: Styles.texteTitre),
                  TextButton(
                    onPressed: () {},
                    child: Text("voir tout", style: Styles.texteTitre),
                  ),
                ],
              ),
              /*  const FiltrageChoiceChipWidget(),*/
              const ListTransactionsWidgets(),
            ],
          ),
        ),
      ),
    );
  }
}
