import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_visibilite_solde.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/views/widgets/depenses_widgets.dart';
import 'package:suivi_budget/views/widgets/revenus_widgets.dart';

class SoldeWidget extends StatefulWidget {
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  EtatVisibiliteSolde _etat = EtatVisibiliteSolde.visible;

  void changerVisibilite() {
    setState(() => _etat = _etat.basculer());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SOLDE TOTAL',
            style: Styles.texteCorps.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
              color: Styles.texteSecondaire(context),
            ),
          ),
          const Gap(6),
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: _etat.estMasque
                      ? Text('******', style: Styles.texteMontant)
                      : Text(
                          FormatMontant.afficherAvecDevise(
                            database.soldeTotal(),
                          ),
                          style: Styles.texteMontant,
                        ),
                ),
              ),
              IconButton(
                tooltip: _etat.estMasque ? 'Afficher le solde' : 'Masquer le solde',
                onPressed: changerVisibilite,
                icon: Icon(
                  _etat.estMasque ? Icons.visibility : Icons.visibility_off,
                ),
              ),
            ],
          ),
          const Gap(20),
          const Divider(),
          const Gap(16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: RevenusWidgets(
                    totalRevenus: database.totalRevenus(),
                    chargement: database.chargement,
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
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
    );
  }
}
