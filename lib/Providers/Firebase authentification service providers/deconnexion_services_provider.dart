import 'package:flutter/foundation.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/deconnexion_service.dart';

class DeconnexionServicesProvider extends ChangeNotifier {
  final DeconnexionService deconnexionService = DeconnexionService();
  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;
  String get message => _message;
  // Deconnecter l'utilisateur
  Future<bool> deconnecterUtilisateur() async {
    _chargement = false;
    notifyListeners();
    try {
      await deconnexionService.deconnecterUtilisateur();
      _chargement = false;
      _message = "Déconnecter avec succès";
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
