import 'package:flutter/foundation.dart';
import 'package:suivi_budget/Services/Firebase%20/Firestore%20services/doc_utilisateur_.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class DocUtilisateurProvider extends ChangeNotifier {
  final DocUtilisateur _documentUtilisateurService = DocUtilisateur();
  String _message = "";

  // Lire les informations du document utilisateurs dans la base de donnée
  Future<Utilisateur?> readUserDoc() async {
    try {
      return await _documentUtilisateurService.readDataOnce();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
      return null;
    }
  }
}
