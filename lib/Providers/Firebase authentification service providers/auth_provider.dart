import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Firebase%20/Authentification%20services/auth.dart';
import 'package:suivi_budget/Services/Firebase%20/Firestore%20services/doc_utilisateur_.dart';
import 'package:suivi_budget/Services/Preferences/utilisateur_preferences.dart';
import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class AuthServicesProvider extends ChangeNotifier {
  final DocUtilisateur _docUtilisateur = DocUtilisateur();
  final UtilisateurPreferences _utilisateurPreferences =
      UtilisateurPreferences();
  final Auth _auth = Auth();
  Auth get firebase => _auth;
  bool _chargement = false;
  bool get chargement => _chargement;
  String _message = "";
  Future createUser({
    required BuildContext context,
    required String nom,
    required String prenom,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final validation = validateUserCreationForm(
        context,
        nom,
        prenom,
        email,
        password,
        passwordConfirmation,
      );
      if (!validation) return;
      _chargement = true;
      notifyListeners();

      // authentifier l'utilisateur
      final UserCredential utilisateur = await _auth.createAccountWithEmail(
        email.trim(),
        password.trim(),
      );
      //Créer le document Utilisateur
      await _docUtilisateur
          .createData(
            Utilisateur(
              userId: utilisateur.user!.uid,
              nom: nom.trim(),
              prenom: prenom.trim(),
              email: email.trim(),
            ),
          )
          .then((value) async {
            // Enregistrer la preference
            return await _utilisateurPreferences.createData([
              nom.trim(),
              prenom.trim(),
              email.trim(),
              password.trim(),
            ]);
          });
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      if (context.mounted) showErrorSnackbar(context, _message);
      notifyListeners();
    }
  }

  Future singInUserWithEmail({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final validation = validateUserConnexinForm(context, email, password);
      if (!validation) {
        return;
      }
      _chargement = true;
      notifyListeners();
      await _auth.signInWithEmail(email.trim(), password.trim());
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }

  Future singInUserAnonymously({required BuildContext context}) async {
    try {
      _chargement = false;
      notifyListeners();
      await _auth.signInAnonymously();
      _chargement = false;
      notifyListeners();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }

  Future signUserOut({required BuildContext context}) async {
    try {
      _chargement = true;
      notifyListeners();
      await _auth.signOut();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }
}
