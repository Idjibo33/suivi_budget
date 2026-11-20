import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/categorie_card.dart';

class CategorieCard extends StatelessWidget {
  final Function(String val) catChoisie;
  final bool choisie;
  final CategorieCardModel card;
  const CategorieCard({
    super.key,
    required this.card,
    required this.choisie,
    required this.catChoisie,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    final Color accent = choisie ? couleurs.primary : couleurs.onSurfaceVariant;

    return SizedBox(
      width: 92,
      child: Tooltip(
        message: card.titre,
        child: InkWell(
          onTap: () => catChoisie(card.titre),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              color: choisie
                  ? couleurs.primaryContainer
                  : Styles.surfaceSecondaire(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: choisie ? couleurs.primary : Colors.transparent,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  card.type == "Revenu"
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 20,
                  color: accent,
                ),
                const Gap(4),
                Text(
                  card.titre,
                  style: Styles.texteCorps.copyWith(
                    fontSize: 11,
                    color: accent,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
