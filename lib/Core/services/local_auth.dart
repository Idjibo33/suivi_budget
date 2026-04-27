import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  final LocalAuthentication auth = LocalAuthentication();
  Future<bool> checkLocalAuthAvailable() async {
    try {
      final bool canAuthenticate = await auth.canCheckBiometrics;
      return canAuthenticate;
    } on LocalAuthException catch (e) {
      throw Exception(e);
    }
  }

  Future<bool> authentication({required String description}) async {
    try {
      final verification = await checkLocalAuthAvailable();
      if (verification) {
        return await auth.authenticate(
          localizedReason: description,
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
