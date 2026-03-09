import 'package:flutter/foundation.dart';
import 'package:suivi_budget/Services/Supabase/database/utilisateur_table.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class UtilisateurTableProvider extends ChangeNotifier {
  final UtilisateurTable _documentUtilisateurService = UtilisateurTable();
  String _message = "";

  // Lire les informations du document utilisateurs dans la base de donnée
  Future<Utilisateur?> readUserRow() async {
    try {
      return await _documentUtilisateurService.readDataOnce();
    } catch (e) {
      _message = e.toString();
      notifyListeners();
      return null;
    }
  }
}
