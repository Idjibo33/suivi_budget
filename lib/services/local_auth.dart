import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

/// Accès à la biométrie locale.
///
/// La vérification n'est proposée que si [estUtilisable] répond vrai :
/// matériel présent, au moins une empreinte enregistrée et plateforme
/// compatible. Aucun dialogue n'est ouvert dans le cas contraire.
class LocalAuth {
  final LocalAuthentication auth = LocalAuthentication();

  /// Vrai uniquement quand l'appareil peut réellement authentifier l'utilisateur.
  ///
  /// [canCheckBiometrics] seul suffit à indiquer la présence du matériel, mais
  /// pas l'existence d'une empreinte enregistrée : [getAvailableBiometrics]
  /// complète donc le contrôle.
  Future<bool> estUtilisable() async {
    if (kIsWeb) {
      return false;
    }
    try {
      final bool supporte = await auth.isDeviceSupported();
      if (!supporte) {
        return false;
      }
      final bool peutVerifier = await auth.canCheckBiometrics;
      if (!peutVerifier) {
        return false;
      }
      final List<BiometricType> empreintes = await auth.getAvailableBiometrics();
      return empreintes.isNotEmpty;
    } catch (error) {
      debugPrint('Biométrie indisponible : $error');
      return false;
    }
  }

  /// Alias historique conservé pour les appels existants.
  Future<bool> checkLocalAuthAvailable() => estUtilisable();

  /// Authentifie l'utilisateur, sauf si l'appelant a déjà vérifié la disponibilité.
  Future<bool> authenticated({
    required String description,
    bool verifierDisponibilite = true,
  }) async {
    try {
      if (verifierDisponibilite && !await estUtilisable()) {
        return false;
      }
      return await auth.authenticate(
        localizedReason: description,
        persistAcrossBackgrounding: true,
      );
    } catch (error) {
      debugPrint(error.toString());
      return false;
    }
  }
}
