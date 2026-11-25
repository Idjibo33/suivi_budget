/// Filtre appliqué à la liste des enveloppes.
enum EtatFiltreBudget {
  enCours('En cours'),
  archives('Archivés');

  const EtatFiltreBudget(this.libelle);

  final String libelle;

  /// Transition nommée : le filtre ne peut prendre que deux valeurs.
  EtatFiltreBudget basculer() => switch (this) {
        enCours => archives,
        archives => enCours,
      };
}
