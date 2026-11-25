import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/helpers/repartition.dart';

/// Répartition des dépenses par catégorie : anneau + légende.
///
/// Les parts sont distinguées par des nuances de teal et de noir, jamais par
/// une couleur de statut. Seuls les montants de dépense (total et légende)
/// restent neutres ; le signe indique une dépense.
class RepartitionCategories extends StatelessWidget {
  final List<LigneRepartition> lignes;

  const RepartitionCategories({super.key, required this.lignes});

  @override
  Widget build(BuildContext context) {
    final int total = totalRepartition(lignes);
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    if (total <= 0) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Aucune dépense sur cette période.',
          style: Styles.texteCorps.copyWith(
            color: Styles.texteSecondaire(context),
          ),
        ),
      );
    }

    final List<Color> palette = AppCouleurs.paletteRepartition(couleurs);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 132,
              height: 132,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: _DonutPainter(lignes: lignes, palette: palette),
                    size: const Size.square(132),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        FormatMontant.afficher(total),
                        style: Styles.texteTitre.copyWith(
                          fontSize: 13,
                          color: Styles.couleurDepense(context),
                        ),
                      ),
                      Text(
                        'dépensés',
                        style: Styles.texteCorps.copyWith(
                          fontSize: 10,
                          color: Styles.texteSecondaire(context),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: Column(
                children: [
                  for (int index = 0; index < lignes.length; index++)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: palette[index % palette.length],
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const Gap(7),
                          Expanded(
                            child: Text(
                              lignes[index].famille,
                              style: Styles.texteCorps.copyWith(fontSize: 11),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            FormatMontant.afficher(lignes[index].montant),
                            style: Styles.texteCorps.copyWith(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Styles.couleurDepense(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.lignes, required this.palette});

  final List<LigneRepartition> lignes;
  final List<Color> palette;

  @override
  void paint(Canvas canvas, Size size) {
    final double total = totalRepartition(lignes).toDouble();
    final Rect zone = Offset.zero & size;
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18;
    double depart = -1.5707963267948966; // -pi/2 : départ en haut.

    for (int index = 0; index < lignes.length; index++) {
      final double angle = lignes[index].montant / total * 6.283185307179586;
      paint.color = palette[index % palette.length];
      canvas.drawArc(zone, depart, angle, false, paint);
      depart += angle;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter old) =>
      old.lignes != lignes || old.palette != palette;
}
