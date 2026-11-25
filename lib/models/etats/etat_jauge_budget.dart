import '../helpers/calcul_budget.dart';

/// État visuel d'une enveloppe. Porté par la forme et le motif de la jauge,
/// jamais par une couleur de statut (le signe et l'icône portent le sens).
enum EtatJaugeBudget {
  sain('Confortable'),
  proche('À surveiller'),
  depasse('Dépassé');

  const EtatJaugeBudget(this.libelle);

  final String libelle;

  /// Transition nommée depuis les totaux calculés sur la période active.
  static EtatJaugeBudget depuisTotaux(TotauxBudget totaux) {
    if (totaux.disponible < 0) {
      return depasse;
    }
    final double seuil = totaux.alloue > 0 ? totaux.alloue * 0.2 : 0;
    return totaux.disponible <= seuil ? proche : sain;
  }
}
