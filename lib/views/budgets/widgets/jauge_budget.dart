import 'package:flutter/material.dart';
import 'package:suivi_budget/models/etats/etat_jauge_budget.dart';
import 'package:suivi_budget/models/helpers/calcul_budget.dart';

/// Jauge dont l'état est porté par la forme et le motif, jamais par une
/// couleur de statut : plein, hachures teal, hachures noires bordées.
class JaugeBudget extends StatelessWidget {
  final TotauxBudget totaux;

  const JaugeBudget({super.key, required this.totaux});

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    final EtatJaugeBudget etat = EtatJaugeBudget.depuisTotaux(totaux);
    final double progression = totaux.alloue <= 0
        ? 0
        : (totaux.depense / totaux.alloue).clamp(0.0, 1.0);

    return Semantics(
      label: 'Jauge ${etat.libelle}',
      child: SizedBox(
        height: 10,
        child: CustomPaint(
          painter: _JaugePainter(
            etat: etat,
            progression: progression,
            couleurs: couleurs,
          ),
        ),
      ),
    );
  }
}

class _JaugePainter extends CustomPainter {
  _JaugePainter({
    required this.etat,
    required this.progression,
    required this.couleurs,
  });

  final EtatJaugeBudget etat;
  final double progression;
  final ColorScheme couleurs;

  @override
  void paint(Canvas canvas, Size size) {
    final RRect piste = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    );
    canvas.drawRRect(piste, Paint()..color = couleurs.surfaceContainerHighest);

    if (progression <= 0) {
      return;
    }
    canvas.save();
    canvas.clipRRect(piste);
    final double largeur = size.width * progression;
    final Rect remplissage = Rect.fromLTWH(0, 0, largeur, size.height);
    final Paint fond = Paint();

    switch (etat) {
      case EtatJaugeBudget.sain:
        fond.color = couleurs.primary;
        canvas.drawRect(remplissage, fond);
      case EtatJaugeBudget.proche:
        fond.color = couleurs.primaryContainer;
        canvas.drawRect(remplissage, fond);
        _hachures(canvas, largeur, size.height, couleurs.primary, 4, 8);
      case EtatJaugeBudget.depasse:
        fond.color = couleurs.surface;
        canvas.drawRect(remplissage, fond);
        _hachures(canvas, largeur, size.height, couleurs.onSurface, 3, 7);
    }
    canvas.restore();

    if (etat == EtatJaugeBudget.depasse) {
      canvas.drawRRect(
        piste.deflate(0.8),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = couleurs.onSurface,
      );
    }
  }

  void _hachures(
    Canvas canvas,
    double largeur,
    double hauteur,
    Color couleur,
    double epaisseur,
    double pas,
  ) {
    final Paint paint = Paint()
      ..color = couleur
      ..strokeWidth = epaisseur;
    for (double x = -hauteur; x < largeur + hauteur; x += pas) {
      canvas.drawLine(Offset(x, hauteur), Offset(x + hauteur, 0), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _JaugePainter old) =>
      old.etat != etat ||
      old.progression != progression ||
      old.couleurs != couleurs;
}
