/// États du verrouillage de l'accueil : vérification, refus, accord.
sealed class EtatAuthentification {
  const EtatAuthentification();

  bool get enVerification => this is EtatAuthentificationVerification;
  bool get authentifie => this is EtatAuthentificationAccordee;
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

EtatAuthentification demarrerAuthentification({
  required bool contournerVerification,
}) =>
    contournerVerification
        ? const EtatAuthentificationAccordee()
        : const EtatAuthentificationVerification();

EtatAuthentification resultatAuthentification(bool reussi) =>
    reussi
        ? const EtatAuthentificationAccordee()
        : const EtatAuthentificationRefusee();

