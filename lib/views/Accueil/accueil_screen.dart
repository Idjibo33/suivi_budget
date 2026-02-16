import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/views/Profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/solde_widget.dart';

class AccueilScreen extends StatelessWidget {
  const AccueilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.couleurbgSecondaire,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
        onPressed: () => naviguerAjouterTransactionPage(context),
        child: Icon(Icons.add),
      ),
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
                  Builder(
                    builder: (context) => GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                      },
                      child: CircleAvatar(
                        backgroundColor: Styles.couleurbgSecondaire,
                        child: Icon(Icons.person_2_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SoldeWidget(),
              const SizedBox(height: 12),
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
            ],
          ),
        ),
      ),
    );
  }
}
