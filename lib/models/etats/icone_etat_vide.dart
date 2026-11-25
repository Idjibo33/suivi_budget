/// Icône d'un état vide, choisie explicitement et sérialisée en base.
enum IconeEtatVide {
  idee('Idée', 'spark'),
  graphique('Graphique', 'chart'),
  portefeuille('Portefeuille', 'wallet'),
  crayon('Crayon', 'edit');

  const IconeEtatVide(this.libelle, this.code);

  final String libelle;
  final String code;

  /// Reconstitue l'icône depuis la valeur stockée en JSON.
  static IconeEtatVide depuisCode(String code) => switch (code) {
        'spark' => idee,
        'chart' => graphique,
        'wallet' => portefeuille,
        'edit' => crayon,
        _ => idee,
      };
}
