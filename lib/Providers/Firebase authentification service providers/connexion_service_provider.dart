import 'package:flutter/foundation.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/connexion_services.dart';

class ConnexionServiceProvider extends ChangeNotifier {
  final ConnexionServces connexionServices = ConnexionServces();
  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;
  String get message => _message;
  // Connecter l'utilisateur
  Future<bool> connecterUtilisateur({
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
        return false;
      }
      await connexionServices.connecterUtilisateur(
        email: email.trim(),
        password: password.trim(),
      );
      _chargement = false;
      _message = "SUccès";
      notifyListeners();
      return true;
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      return false;
    }
  }
}
