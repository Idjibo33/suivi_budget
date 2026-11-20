/// États du verrouillage de l'accueil : vérification, refus, accord ou
/// biométrie indisponible (vérification ignorée).
sealed class EtatAuthentification {
  const EtatAuthentification();

  bool get enVerification => this is EtatAuthentificationVerification;
  bool get authentifie => this is EtatAuthentificationAccordee;

  /// L'accueil est accessible sans authentification.
  bool get accueilAccessible =>
      this is EtatAuthentificationAccordee ||
      this is EtatAuthentificationIgnoree;
}

final class EtatAuthentificationVerification extends EtatAuthentification {
  const EtatAuthentificationVerification();
}

final class EtatAuthentificationRefusee extends EtatAuthentification {
  const EtatAuthentificationRefusee();
}

final class EtatAuthentificationAccordee extends EtatAuthentification {
  const EtatAuthentificationAccordee();
}

/// La biométrie n'est pas utilisable : l'app s'ouvre directement.
final class EtatAuthentificationIgnoree extends EtatAuthentification {
  const EtatAuthentificationIgnoree();
}

EtatAuthentification demarrerAuthentification({
  required bool contournerVerification,
}) =>
    contournerVerification
        ? const EtatAuthentificationIgnoree()
        : const EtatAuthentificationVerification();

EtatAuthentification resultatAuthentification(bool reussi) =>
    reussi
        ? const EtatAuthentificationAccordee()
        : const EtatAuthentificationRefusee();

/// Transition explicite après le contrôle de disponibilité de la biométrie.
EtatAuthentification resultatDisponibiliteBiometrie(bool disponible) =>
    disponible
        ? const EtatAuthentificationVerification()
        : const EtatAuthentificationIgnoree();
