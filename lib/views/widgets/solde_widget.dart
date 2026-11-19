import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/depenses_widgets.dart';
import 'package:suivi_budget/views/widgets/revenus_widgets.dart';

class SoldeWidget extends StatefulWidget {
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  bool visible = false;

  void changerVisibilite() {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Align(
                alignment: AlignmentGeometry.topLeft,
                child: Text("Nom utilisateur", style: Styles.texteCorps),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: visible
                          ? Text("******", style: Styles.texteCorps)
                          : Text(
                              "${database.soldeTotal()} F CFA",
                              style: Styles.texteTitre,
                            ),
                    ),
                  ),

                  Stack(
                    children: [
                      Visibility(
                        visible: visible,
                        child: IconButton(
                          onPressed: () => changerVisibilite(),
                          icon: Icon(Icons.visibility),
                        ),
                      ),
                      Visibility(
                        visible: !visible,
                        child: IconButton(
                          onPressed: () => changerVisibilite(),
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
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: RevenusWidgets(
                        totalRevenus: database.totalRevenus(),
                        chargement: database.chargement,
                      ),
                    ),
                  ),
                  const Gap(8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: DepensesWidgets(
                        totalDepenses: database.totalDepenses(),
                        chargement: database.chargement,
                      ),
                    ),
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
