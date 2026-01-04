import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/providers.dart';
import 'package:suivi_budget/widgets/depenses_widgets.dart';
import 'package:suivi_budget/widgets/onBoarding_widget.dart';
import 'package:suivi_budget/widgets/revenus_widgets.dart';
import 'package:suivi_budget/widgets/solde_widget.dart';
import 'package:suivi_budget/widgets/transaction_card.dart';

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final nom = context.read<UtilisateurInfoProvider>().nom;
      if (nom == "Utilisateur") {
        return entrerInfos();
      }
    });
  }

  void entrerInfos() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => OnboardingWidget(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final monNom = context.watch<UtilisateurInfoProvider>().nom;
    final mesTransactions = context.watch<DatabaseProvider>().transactions;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Gap(22),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: FittedBox(
                child: Text("Suivi budget", style: Styles.texteEnTete),
              ),
            ),
            Gap(20),
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
            Gap(22),
            const SoldeWidget(),
            Gap(12),
            Align(
              alignment: Alignment.topLeft,
              child: Text("Statistiques", style: Styles.texteTitre),
            ),
            Gap(4),
            Row(
              children: [
                Expanded(child: const RevenusWidgets()),
                Expanded(child: const DepensesWidgets()),
              ],
            ),
            Gap(12),
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text("Transactions récents", style: Styles.texteTitre),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: mesTransactions.length,
                itemBuilder: (context, index) {
                  return TransactionCard(transaction: mesTransactions[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
