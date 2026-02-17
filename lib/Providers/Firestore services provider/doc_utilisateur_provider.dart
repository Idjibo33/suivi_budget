import 'package:flutter/foundation.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/Utilisateur%20services/document_utilisateur_service.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class DocUtilisateurProvider extends ChangeNotifier {
  final DocumentUtilisateurService _documentUtilisateurService =
      DocumentUtilisateurService();
  Utilisateur? utilisateur;
  String _message = "";
  String get message => _message;
  // Lire les informations du document utilisateurs dans la base de donnée
  Future chargerDocUtilisateur() async {
    try {
      utilisateur = await _documentUtilisateurService.lireDocUtilisateur();
      if (utilisateur != null) {
        _message = "Chargé avec succès";
        notifyListeners();
      }
      _message = "Une erreur est survenue";
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
    }
  }
}
