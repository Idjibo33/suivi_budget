import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/get_it.dart';
import 'package:suivi_budget/Core/services/local_auth.dart';

class LocalAuthProvider extends ChangeNotifier {
  final service = getIt<LocalAuth>();
  Future<bool> authenticate() async {
    try {
      final authentication = await getIt<LocalAuth>().authentication(
        description: "Authentifier-vous pour continuer",
      );
      if (!authentication) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
