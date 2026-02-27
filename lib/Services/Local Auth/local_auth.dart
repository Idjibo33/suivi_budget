import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  final LocalAuthentication auth = LocalAuthentication();
  // verifier si le logiciel supporte
  Future<bool> checkLocalAuthAvailable() async {
    try {
      final bool canAuthenticate = await auth.canCheckBiometrics;
      return canAuthenticate;
    } on LocalAuthException catch (e) {
      throw Exception(e);
    }
  }

  //Authentifier
  Future<bool> authenticated() async {
    try {
      final verification = await checkLocalAuthAvailable();
      if (verification) {
        return await auth.authenticate(
          localizedReason: "Authentifier-vous pour voir le solde",
          persistAcrossBackgrounding: true,
        );
      } else {
        return false;
      }
    } on LocalAuthException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
