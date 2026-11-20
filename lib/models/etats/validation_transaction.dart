import 'package:suivi_budget/models/helpers/format_montant.dart';

/// Résultat d'une validation de montant : valide ou invalide avec message.
sealed class ResultatValidationMontant {
  const ResultatValidationMontant();
}

final class MontantValide extends ResultatValidationMontant {
  const MontantValide(this.montant);

  final int montant;
}

final class MontantInvalide extends ResultatValidationMontant {
  const MontantInvalide(this.message);

  final String message;
}

const String messageMontantInvalide = 'Veuillez saisir un montant valide';
const String messageSoldeInsuffisant = 'Solde insuffisant';

/// Parse, contrôle la positivité et, si fourni, le solde disponible.
ResultatValidationMontant validerMontant(
  String saisie, {
  int? soldeDisponible,
}) {
  final int? montant = FormatMontant.lire(saisie.trim());
  if (montant == null || montant <= 0) {
    return const MontantInvalide(messageMontantInvalide);
  }
  if (soldeDisponible != null && montant > soldeDisponible) {
    return const MontantInvalide(messageSoldeInsuffisant);
  }
  return MontantValide(montant);
}
