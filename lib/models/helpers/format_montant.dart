import 'package:intl/intl.dart';

/// Formatage centralisé des montants affichés par l'application.
///
/// Les montants sont stockés en `int` (voir `Transaction.montant`) et toujours
/// exprimés en francs CFA. Le regroupement français utilise l'espace fine
/// insécable produite par `intl`, y compris dans le champ de saisie : la
/// validation nettoie ces espaces avant de parser la valeur.
abstract final class FormatMontant {
  static final NumberFormat _format = NumberFormat.decimalPattern('fr_FR');

  /// Montants proposés sous forme de `ChoiceChip` à la création.
  static const List<int> suggestions = [1000, 5000, 10000, 25000];

  /// `12 500` : regroupement français, sans signe ni devise.
  static String afficher(int montant) => _format.format(montant);

  /// `12 500 F CFA` : utilisé pour les soldes et totaux.
  static String afficherAvecDevise(int montant) =>
      '${afficher(montant)} F CFA';

  /// `+12 500 F CFA` ou `-12 500 F CFA` : le signe porte le sens,
  /// aucune couleur de statut n'est nécessaire.
  static String afficherAvecSigne(
    int montant, {
    required bool estRevenu,
    bool devise = true,
  }) {
    final String valeur = '${estRevenu ? '+' : '-'}${afficher(montant.abs())}';
    return devise ? '$valeur F CFA' : valeur;
  }

  /// Valeur à placer dans le champ de saisie : regroupée, sans devise ni signe.
  static String pourSaisie(int montant) => afficher(montant);

  /// Supprime les espaces de regroupement (espace, insécable, fine insécable).
  static String nettoyer(String saisie) => saisie
      .replaceAll('\u202F', '')
      .replaceAll('\u00A0', '')
      .replaceAll(' ', '');

  /// Parse une saisie formatée. `null` si la valeur n'est pas un entier.
  static int? lire(String saisie) => int.tryParse(nettoyer(saisie));
}
