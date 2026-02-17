import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Transactions/Depenses/ajouter_depense_view.dart';
import 'package:suivi_budget/views/Transactions/Revenus/ajouter_revenu_view.dart';

class AjouterTransaction extends StatefulWidget {
  const AjouterTransaction({super.key});

  @override
  State<AjouterTransaction> createState() => _AjouterTransactionState();
}

class _AjouterTransactionState extends State<AjouterTransaction> {
  // le controlleur du champ d'entrée du montant
  final TextEditingController montanttexte = TextEditingController();
  @override
  void dispose() {
    montanttexte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter une transaction"),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelStyle: Styles.texteCorps,
            tabs: [
              Text("Revenu", style: Styles.texteTitre),
              Text("Dépense", style: Styles.texteTitre),
            ],
          ),
        ),
        body: TabBarView(
          children: [const AjouterRevenuView(), const AjouterDepenseView()],
        ),
      ),
    );
  }
}
