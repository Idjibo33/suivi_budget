import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/providers.dart';

class SoldeWidget extends StatefulWidget {
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  bool montantVisible = false;

  @override
  Widget build(BuildContext context) {
    final monNom = context.watch<UtilisateurInfoProvider>().nom;
    int monSolde = context.watch<DatabaseProvider>().calculerSolde();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Align(
              alignment: AlignmentGeometry.topLeft,
              child: Text("Solde", style: Styles.texteTitre),
            ),
            Gap(4),
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
                      child: Text(
                        monSolde.toString(),
                        style: Styles.texteTitre,
                      ),
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
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(monNom.toString(), style: Styles.texteCorps),
            ),
          ],
        ),
      ),
    );
  }
}
