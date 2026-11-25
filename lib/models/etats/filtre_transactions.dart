import 'package:suivi_budget/models/transaction.dart';

/// Filtre de la feuille « toutes les transactions » ouverte depuis l'accueil.
///
/// Les trois valeurs sont explicites : aucun booléen ou chaîne combinée ne
/// représente le choix courant.
enum FiltreTransactions {
  toutes('Toutes'),
  revenus('Revenus'),
  depenses('Dépenses');

  const FiltreTransactions(this.libelle);

  /// Libellé des puces de filtre, utilisé aussi dans le titre de la feuille.
  final String libelle;

  /// Transition nommée : sélectionner une puce remplace le filtre courant.
  FiltreTransactions selectionner(FiltreTransactions nouveau) => nouveau;

  /// Le type est stocké tel quel en base : `"Revenu"` ou `"Depense"`.
  bool accepte(Transaction transaction) => switch (this) {
    FiltreTransactions.toutes => true,
    FiltreTransactions.revenus => transaction.type == 'Revenu',
    FiltreTransactions.depenses => transaction.type == 'Depense',
  };
}
