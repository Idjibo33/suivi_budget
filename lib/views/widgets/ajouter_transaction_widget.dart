import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/models/etats/etat_onglet_transaction.dart';
import 'package:suivi_budget/views/transactions/depenses/ajouter_depense_view.dart';
import 'package:suivi_budget/views/transactions/revenus/ajouter_revenu_view.dart';

/// Formulaire d'ajout avec deux onglets explicites.
///
/// L'ancien `TabController` provoquait une assertion lors d'un changement de
/// thème pendant la reconstruction du `TabBarView`. Un état simple et un
/// `switch` exhaustif évitent toute animation de contrôleur.
class AjouterTransaction extends StatefulWidget {
  const AjouterTransaction({
    super.key,
    this.ongletInitial = EtatOngletTransaction.revenu,
  });

  final EtatOngletTransaction ongletInitial;

  @override
  State<AjouterTransaction> createState() => _AjouterTransactionState();
}

class _AjouterTransactionState extends State<AjouterTransaction> {
  late EtatOngletTransaction _onglet = widget.ongletInitial;

  /// Transition nommée : un choix identique ne reconstruit pas l'écran.
  void choisirOnglet(EtatOngletTransaction nouvelOnglet) {
    if (nouvelOnglet == _onglet) {
      return;
    }
    setState(() => _onglet = nouvelOnglet);
  }

  Widget vueSelectionnee() => switch (_onglet) {
    EtatOngletTransaction.revenu => const AjouterRevenuView(),
    EtatOngletTransaction.depense => const AjouterDepenseView(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter une transaction"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: SegmentedButton<EtatOngletTransaction>(
                  showSelectedIcon: false,
                  segments: [
                    for (final EtatOngletTransaction onglet
                        in EtatOngletTransaction.values)
                      ButtonSegment<EtatOngletTransaction>(
                        value: onglet,
                        label: Text(onglet.libelle),
                        icon: Icon(onglet.icone, size: 18),
                      ),
                  ],
                  selected: {_onglet},
                  onSelectionChanged: (Set<EtatOngletTransaction> selection) =>
                      choisirOnglet(selection.first),
                ),
              ),
            ),
            const Gap(4),
            Expanded(child: vueSelectionnee()),
          ],
        ),
      ),
    );
  }
}
