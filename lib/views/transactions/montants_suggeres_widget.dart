import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';

/// Montants fréquents proposés sous forme de `ChoiceChip`.
///
/// Le champ reste la source de vérité : la sélection est déduite de son texte
/// et un choix remplace simplement ce texte par une valeur formatée, que
/// [FormatMontant.lire] sait à nouveau valider.
class MontantsSuggeresWidget extends StatelessWidget {
  final TextEditingController controleur;

  const MontantsSuggeresWidget({super.key, required this.controleur});

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controleur,
      builder: (context, valeur, child) {
        final int? montantSaisi = FormatMontant.lire(valeur.text);

        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final int montant in FormatMontant.suggestions)
              ChoiceChip(
                label: Text(FormatMontant.afficher(montant)),
                selected: montantSaisi == montant,
                showCheckmark: false,
                onSelected: (_) {
                  controleur.text = FormatMontant.pourSaisie(montant);
                  controleur.selection = TextSelection.collapsed(
                    offset: controleur.text.length,
                  );
                  FocusScope.of(context).unfocus();
                },
                labelStyle: Styles.texteCorps.copyWith(
                  color: montantSaisi == montant
                      ? couleurs.onPrimaryContainer
                      : couleurs.onSurface,
                ),
                selectedColor: couleurs.primaryContainer,
                backgroundColor: couleurs.surfaceContainerHighest,
                side: BorderSide(color: Styles.bordure(context)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
          ],
        );
      },
    );
  }
}
