import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/ajouter_depense_view.dart';
import 'package:suivi_budget/Features/transactions/presentation/widgets/ajouter_revenu_screen.dart';

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
            dividerHeight: 0,
            unselectedLabelStyle: texteCorps,
            tabs: [
              Text("Revenu", style: texteTitre),
              Text("Dépense", style: texteTitre),
            ],
          ),
        ),
        body: TabBarView(
          children: [const AjouterRevenuScreen(), const AjouterDepenseView()],
        ),
      ),
    );
  }
}
