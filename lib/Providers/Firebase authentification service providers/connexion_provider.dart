import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/connexion.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/navigation/naviguer_auth_gate.dart';

class ConnexionProvider extends ChangeNotifier {
  final Connexion connexionServices = Connexion();
  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;
  // Connecter l'utilisateur
  Future connecterUtilisateur({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    _chargement = true;
    notifyListeners();
    try {
      if (email.isEmpty || password.isEmpty) {
        _chargement = false;
        _message = "toutes les cases sont obligatoires";
        notifyListeners();
      }
      await connexionServices.connecterUtilisateur(
        email: email.trim(),
        password: password.trim(),
      );
      _chargement = false;
      _message = "Succès";
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, _message);
        naviguerAuthGate(context);
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) {
        showErrorSnackbar(context, _message);
      }
    }
  }
}
