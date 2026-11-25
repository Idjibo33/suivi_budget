import 'dart:ui' show FontFeature;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_visibilite_solde.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/providers/database_provider.dart';

class SoldeWidget extends StatefulWidget {
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  EtatVisibiliteSolde _etat = EtatVisibiliteSolde.visible;

  @override
  Widget build(BuildContext context) {
    final database = context.watch<DatabaseProvider>();
    final couleurs = Theme.of(context).colorScheme;
    final maintenant = DateTime.now();
    var revenus = 0;
    var depenses = 0;
    for (final transaction in database.transactionsListe) {
      final date = DateTime.tryParse(transaction.date)?.toLocal();
      if (date?.year != maintenant.year || date?.month != maintenant.month) {
        continue;
      }
      if (transaction.estRevenu) revenus += transaction.montant;
      if (transaction.estDepense) depenses += transaction.montant;
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: couleurs.primaryContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(child: Text('Solde actuel')),
                IconButton(
                  tooltip: _etat.estMasque
                      ? 'Afficher le solde'
                      : 'Masquer le solde',
                  onPressed: () => setState(() => _etat = _etat.basculer()),
                  icon: Icon(
                    _etat.estMasque ? Icons.visibility : Icons.visibility_off,
                  ),
                ),
              ],
            ),
            Text(
              _etat.estMasque
                  ? '******'
                  : FormatMontant.afficherAvecDevise(database.soldeTotal()),
              style: Styles.texteMontant.copyWith(
                color: couleurs.onPrimaryContainer,
                fontFeatures: [const FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 12),
            Divider(color: couleurs.onPrimaryContainer.withValues(alpha: 0.18)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _flux(
                    'Revenus du mois',
                    revenus,
                    true,
                    couleurs.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _flux(
                    'Dépenses du mois',
                    depenses,
                    false,
                    couleurs.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _flux(String libelle, int montant, bool estRevenu, Color couleur) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(libelle),
        const SizedBox(height: 4),
        Text(
          montant == 0
              ? FormatMontant.afficherAvecDevise(0)
              : FormatMontant.afficherAvecSigne(montant, estRevenu: estRevenu),
          style: Styles.texteMontantCompact.copyWith(
            color: couleur,
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
