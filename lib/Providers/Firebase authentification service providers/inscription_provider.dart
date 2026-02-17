import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/Providers/Preferences%20provider/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/inscription.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/Utilisateur%20services/creer_doc_utilisateur.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/error_snackbar.dart';
import 'package:suivi_budget/models/Snackbar%20Notifications/success_snackbar.dart';
import 'package:suivi_budget/models/navigation/naviguer_auth_gate.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class InscriptionProvider extends ChangeNotifier {
  final UtilisateurPreferencesProvider _preferencesProvider =
      UtilisateurPreferencesProvider();
  final InscriptionService _inscriptionService = InscriptionService();
  String _message = "";
  bool _chargement = false;
  bool get chargement => _chargement;
  //Inscrire l'utilisateur avec un email et un mot de passe et ajouter ses informations dans la base de donnée
  Future inscrireUtilisateur({
    required BuildContext context,
    required String nom,
    required String prenom,
    required String email,
    required String password,
  }) async {
    _chargement = true;
    notifyListeners();
    try {
      if (nom.isEmpty || prenom.isEmpty || email.isEmpty || password.isEmpty) {
        _chargement = false;
        _message = "Toutes les cases sont obligatoires";
        notifyListeners();
      }
      if (password.length < 6) {
        _chargement = false;
        _message = "Le mot de passe doit avoir au minimum 6 caractères";
        notifyListeners();
      }
      final UserCredential? utilisateur = await _inscriptionService
          .inscrireUtilisateur(email: email.trim(), password: password.trim());
      if (utilisateur != null) {
        //Créer le document de l'utilisateur dans la base de donnée
        await CreerDocUtilisateur().creerDocUtilisateur(
          utilisateur: Utilisateur(
            userId: utilisateur.user!.uid,
            nom: nom.trim(),
            prenom: prenom.trim(),
            email: email.trim(),
          ),
        );
        _preferencesProvider.enregistrerDetailsUtilisateur(
          infos: [nom.trim(), prenom.trim(), email.trim()],
        );
        _chargement = false;
        _message = "Succès";
        notifyListeners();
        if (context.mounted) {
          showSuccessSnackbar(context, _message);
          naviguerAuthGate(context);
        }
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
