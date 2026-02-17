import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/deconnexion.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/navigation/naviguer_auth_gate.dart';

class DeconnexionProvider extends ChangeNotifier {
  final DeconnexionService deconnexionService = DeconnexionService();
  bool _chargement = false;
  String _message = "";
  bool get chargement => _chargement;
  String get message => _message;
  // Deconnecter l'utilisateur
  Future deconnecterUtilisateur(BuildContext context) async {
    _chargement = false;
    notifyListeners();
    try {
      await deconnexionService.deconnecterUtilisateur();
      _chargement = false;
      _message = "Déconnecter avec succès";
      notifyListeners();
      if (context.mounted) {
        showSuccessSnackbar(context, message);
        naviguerAuthGate(context);
      }
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) {
        showErrorSnackbar(context, message);
      }
    }
  }
}
