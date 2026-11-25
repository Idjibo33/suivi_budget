import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';

/// Sélection en cours dans le sheet de modification d'une transaction.
///
/// Tant que l'utilisateur n'a rien choisi, le formulaire retombe sur les
/// identifiants d'origine ; dès un choix explicite, l'état porte la catégorie
/// et/ou l'enveloppe retenue. Les transitions nommées évitent deux drapeaux
/// parallèles et rendent le type affiché toujours déductible de la catégorie.
sealed class SelectionModificationTransaction {
  const SelectionModificationTransaction();

  Categorie? get categorie => switch (this) {
        SelectionModificationInitiale() => null,
        SelectionModificationChoisie(:final categorie) => categorie,
      };

  Budget? get budget => switch (this) {
        SelectionModificationInitiale() => null,
        SelectionModificationChoisie(:final budget) => budget,
      };

  SelectionModificationTransaction avecCategorie(Categorie valeur) =>
      SelectionModificationChoisie(categorie: valeur, budget: budget);

  SelectionModificationTransaction avecBudget(Budget valeur) =>
      SelectionModificationChoisie(categorie: categorie, budget: valeur);
}

final class SelectionModificationInitiale
    extends SelectionModificationTransaction {
  const SelectionModificationInitiale();
}

final class SelectionModificationChoisie
    extends SelectionModificationTransaction {
  const SelectionModificationChoisie({this.categorie, this.budget});

  @override
  final Categorie? categorie;

  @override
  final Budget? budget;
}
