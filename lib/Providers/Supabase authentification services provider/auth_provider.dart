import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Preferences/utilisateur_preferences.dart';
import 'package:suivi_budget/Services/Supabase/Auth/auth.dart';
import 'package:suivi_budget/Services/Supabase/database/utilisateur_table.dart';
import 'package:suivi_budget/models/helpers.dart';
import 'package:suivi_budget/models/utilisateur.dart';

class AuthServicesProvider extends ChangeNotifier {
  final UtilisateurTable _docUtilisateur = UtilisateurTable();
  final UtilisateurPreferences _utilisateurPreferences =
      UtilisateurPreferences();
  final SupabaseAuth _supabase = SupabaseAuth();
  SupabaseAuth get supabase => _supabase;
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
      final utilisateur = await _supabase.createAccountWithEmail(
        email.trim(),
        password.trim(),
      );
      //Créer le document Utilisateur
      await _docUtilisateur
          .createData(
            Utilisateur(
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
      await _supabase.signInWithEmail(email.trim(), password.trim());
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
      await _supabase.signInAnonymously();
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
      await _supabase.signOut();
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      if (context.mounted) showErrorSnackbar(context, _message);
    }
  }
}
