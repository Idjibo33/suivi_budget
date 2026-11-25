/// Type d'une catégorie, et donc sens de la transaction associée.
///
/// Le type n'est pas dupliqué dans la transaction : il est déduit de la
/// catégorie choisie, ce qui empêche une catégorie de revenu d'être utilisée
/// comme une dépense.
enum TypeCategorie {
  revenu('Revenu'),
  depense('Depense');

  const TypeCategorie(this.libelle);

  final String libelle;

  static TypeCategorie depuisCode(String code) => switch (code) {
        'Revenu' => revenu,
        'Depense' => depense,
        _ => throw ArgumentError.value(code, 'code', 'Type de catégorie inconnu'),
      };
}
