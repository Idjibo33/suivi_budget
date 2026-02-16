import 'package:flutter/material.dart';
import 'package:suivi_budget/Providers/Preferences%20provider/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/depenses_widgets.dart';
import 'package:suivi_budget/views/widgets/revenus_widgets.dart';

class SoldeWidget extends StatefulWidget {
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  bool montantVisible = false;

  @override
  Widget build(BuildContext context) {
    // Les informations de l'utilisateur
    final UtilisateurPreferencesProvider infosUtilisateur =
        UtilisateurPreferencesProvider();
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text("${infosUtilisateur.nom}", style: Styles.texteCorps),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    Visibility(
                      visible: !montantVisible,
                      child: Text("******", style: Styles.texteCorps),
                    ),
                    Visibility(
                      visible: montantVisible,
                      child: Text("Solde", style: Styles.texteTitre),
                    ),
                  ],
                ),

                Stack(
                  children: [
                    Visibility(
                      visible: !montantVisible,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            montantVisible = true;
                          });
                        },
                        icon: Icon(Icons.visibility),
                      ),
                    ),
                    Visibility(
                      visible: montantVisible,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            montantVisible = false;
                          });
                        },
                        icon: Icon(Icons.visibility_off),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const RevenusWidgets(), const DepensesWidgets()],
            ),
          ],
        ),
      ),
    );
  }
}
