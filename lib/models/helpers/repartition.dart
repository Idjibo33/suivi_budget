import '../categorie.dart';
import '../transaction.dart';

/// Ligne d'un graphique de répartition, ramenée au domaine.
///
/// Le regroupement se fait par famille de catégories : le nom de chaque
/// catégorie n'est pas affiché dans les graphiques.
typedef LigneRepartition = ({String famille, int montant});

/// Regroupe les dépenses par catégorie pour les graphiques.
///
/// Les revenus sont exclus : un budget mesure ce qui sort de l'enveloppe.
/// Les lignes sans catégorie connue sont regroupées sous « Autre » pour ne
/// jamais perdre un montant dans un graphique.
List<LigneRepartition> repartitionParCategorie({
  required Iterable<Transaction> transactions,
  required Iterable<Categorie> categories,
}) {
  final Map<int, Categorie> parId = {
    for (final categorie in categories)
      if (categorie.id != null) categorie.id!: categorie,
  };
  final Map<String, LigneRepartition> lignes = <String, LigneRepartition>{};

  for (final Transaction transaction in transactions) {
    if (!transaction.estDepense) {
      continue;
    }
    final Categorie? categorie = parId[transaction.categorieId];
    final String famille = categorie?.famille ?? 'Autre';
    final LigneRepartition? existante = lignes[famille];
    lignes[famille] = (
      famille: famille,
      montant: (existante?.montant ?? 0) + transaction.montant,
    );
  }

  final List<LigneRepartition> resultat = lignes.values.toList()
    ..sort((a, b) => b.montant.compareTo(a.montant));
  return resultat;
}

int totalRepartition(Iterable<LigneRepartition> lignes) =>
    lignes.fold(0, (total, ligne) => total + ligne.montant);
