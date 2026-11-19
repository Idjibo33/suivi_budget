import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  final LocalAuthentication auth = LocalAuthentication();

  // verifier si le logiciel supporte
  Future<bool> checkLocalAuthAvailable() async {
    if (kIsWeb) {
      return false;
    }
    try {
      return await auth.canCheckBiometrics;
    } catch (error) {
      debugPrint('Biométrie indisponible : $error');
      return false;
    }
  }

  //Authentifier
  Future<bool> authenticated({required String description}) async {
    try {
      final bool verification = await checkLocalAuthAvailable();
      if (!verification) {
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
