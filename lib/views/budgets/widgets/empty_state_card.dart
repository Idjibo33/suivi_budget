import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/icone_etat_vide.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';

/// Carte d'état vide dont le titre, le texte, le bouton, l'icône et le motif
/// sont personnalisables.
class EmptyStateCard extends StatelessWidget {
  final ModeleEtatVide modele;
  final VoidCallback? onAction;

  const EmptyStateCard({super.key, required this.modele, this.onAction});

  IconData get icone => switch (modele.icone) {
    IconeEtatVide.idee => Icons.auto_awesome_outlined,
    IconeEtatVide.graphique => Icons.bar_chart_outlined,
    IconeEtatVide.portefeuille => Icons.account_balance_wallet_outlined,
    IconeEtatVide.crayon => Icons.edit_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: couleurs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Styles.bordure(context)),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _MotifPainter(
                  motif: modele.motif,
                  couleur: couleurs.primary.withValues(alpha: 0.16),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: couleurs.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icone, color: couleurs.primary),
              ),
              const Gap(12),
              Text(
                modele.titre,
                style: Styles.texteTitre,
                textAlign: TextAlign.center,
              ),
              const Gap(6),
              Text(
                modele.corps,
                style: Styles.texteCorps.copyWith(
                  fontSize: 12,
                  color: Styles.texteSecondaire(context),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(14),
              FilledButton(onPressed: onAction, child: Text(modele.cta)),
            ],
          ),
        ],
      ),
    );
  }
}

class _MotifPainter extends CustomPainter {
  _MotifPainter({required this.motif, required this.couleur});

  final MotifEtatVide motif;
  final Color couleur;

  @override
  void paint(Canvas canvas, Size size) {
    if (motif == MotifEtatVide.uni) {
      return;
    }
    final Paint paint = Paint()..color = couleur;
    if (motif == MotifEtatVide.points) {
      for (double x = 10; x < size.width; x += 18) {
        for (double y = 10; y < size.height; y += 18) {
          canvas.drawCircle(Offset(x, y), 2, paint);
        }
      }
      return;
    }
    paint.strokeWidth = 5;
    for (double x = -size.height; x < size.width; x += 16) {
      canvas.drawLine(
        Offset(x, size.height),
        Offset(x + size.height, 0),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MotifPainter old) =>
      old.motif != motif || old.couleur != couleur;
}
