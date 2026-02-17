import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/solde_provider.dart';
import 'package:suivi_budget/Providers/Preferences%20provider/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/depenses_widgets.dart';
import 'package:suivi_budget/views/widgets/revenus_widgets.dart';

class SoldeWidget extends StatelessWidget {
  const SoldeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Les informations de l'utilisateur
    final infosUtilisateur = context.watch<UtilisateurPreferencesProvider>();

    return Consumer<SoldeProvider>(
      builder: (context, value, child) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: FutureBuilder(
                  future: infosUtilisateur.chargerNom(),
                  builder: (context, snapshot) => Text(
                    "${infosUtilisateur.prenom} ${infosUtilisateur.nom}",
                    style: Styles.texteCorps,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Visibility(
                        visible: !value.visible,
                        child: Text("******", style: Styles.texteCorps),
                      ),
                      Visibility(
                        visible: value.visible,
                        child: Text(
                          "${value.soldeTotal().toString()} F CFA",
                          style: Styles.texteTitre,
                        ),
                      ),
                    ],
                  ),

                  Stack(
                    children: [
                      Visibility(
                        visible: !value.visible,
                        child: IconButton(
                          onPressed: () => value.changervisiblite(),
                          icon: Icon(Icons.visibility),
                        ),
                      ),
                      Visibility(
                        visible: value.visible,
                        child: IconButton(
                          onPressed: () => value.changervisiblite(),
                          icon: Icon(Icons.visibility_off),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RevenusWidgets(
                    totalRevenus: value.totalRevenus(),
                    chargement: value.chargement,
                  ),
                  DepensesWidgets(
                    totalDepenses: value.totalDepenses(),
                    chargement: value.chargement,
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
