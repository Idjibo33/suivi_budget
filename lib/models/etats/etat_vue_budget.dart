/// Vue de l'écran Budgets : données réelles ou aperçu de l'état vide.
enum EtatVueBudget {
  donnees('Données'),
  vide('Aperçu vide');

  const EtatVueBudget(this.libelle);

  final String libelle;

  EtatVueBudget basculer() => switch (this) {
        donnees => vide,
        vide => donnees,
      };
}
