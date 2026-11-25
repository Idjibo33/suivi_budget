import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';

/// Carte d'enveloppe affichée quand aucun budget n'est encore actif.
///
/// Elle reprend le vocabulaire visuel de [BudgetCard] (icône portefeuille,
/// titre, texte et CTA) tout en conservant les textes du modèle personnalisable.
/// Toute la carte et le bouton déclenchent la même action.
class CarteBudgetVide extends StatelessWidget {
  final ModeleEtatVide modele;
  final VoidCallback onAction;
  final VoidCallback? onPersonnaliser;

  const CarteBudgetVide({
    super.key,
    required this.modele,
    required this.onAction,
    this.onPersonnaliser,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 220,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAction,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: couleurs.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Styles.bordure(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 18,
                      color: couleurs.primary,
                    ),
                    const Gap(6),
                    Expanded(
                      child: Text(
                        modele.titre,
                        style: Styles.texteTitre.copyWith(fontSize: 13),
                        maxLines: 2,
                      ),
                    ),
                    if (onPersonnaliser != null)
                      IconButton(
                        tooltip: 'Modifier le modèle',
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        color: Styles.texteSecondaire(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints.tightFor(
                          width: 28,
                          height: 28,
                        ),
                        onPressed: onPersonnaliser,
                      ),
                  ],
                ),
                const Gap(6),
                Text(
                  modele.corps,
                  style: Styles.texteCorps.copyWith(
                    fontSize: 11,
                    color: Styles.texteSecondaire(context),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: onAction,
                    child: Text(modele.cta),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
