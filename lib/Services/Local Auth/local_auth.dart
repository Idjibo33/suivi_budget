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

  // liste des biometrics
  Future<List<String>> getAvailableBiometrics() async {
    try {
      final List<BiometricType> canAuthenticate = await auth
          .getAvailableBiometrics();
      final List<String> biometrics = [];
      for (var x in canAuthenticate) {
        biometrics.add(x.toString());
      }
      return biometrics;
    } on LocalAuthException catch (e) {
      throw Exception(e);
    }
  }

  //Authentifier
  Future<bool> authenticated() async {
    try {
      return await auth.authenticate(
        localizedReason: "Authentifier pour voir le solde",
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
