import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/inscription_service.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/creer_document_utilisateur_service.dart';

class InscriptionServiceProvider extends ChangeNotifier {
  final InscriptionService _inscriptionService = InscriptionService();
  String _message = "";
  bool _chargement = false;
  String get message => _message;
  bool get chargement => _chargement;
  //Inscrire l'utilisateur avec un email et un mot de passe et ajouter ses informations dans la base de donnée
  Future<bool> inscrireUtilisateur({
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
        return false;
      }
      if (password.length < 6) {
        _chargement = false;
        _message = "Le mot de passe doit avoir au minimum 6 caractères";
        notifyListeners();
        return false;
      }
      final UserCredential? utilisateur = await _inscriptionService
          .inscrireUtilisateur(email: email.trim(), password: password.trim());
      if (utilisateur != null) {
        //Créer le document de l'utilisateur dans la base de donnée
        await CreerDocumentUtilisateurService().creerDocUtilisateur(
          idUtilisateur: utilisateur.user!.uid,
          nom: nom.trim(),
          prenom: prenom.trim(),
          email: email.trim(),
        );
        _chargement = false;
        _message = "Succès";
        notifyListeners();
        return true;
      }
      _chargement = false;
      _message = "Une erreur est survenue";
      notifyListeners();
      return false;
    } catch (e) {
      _chargement = false;
      _message = e.toString();
      notifyListeners();
      return false;
    }
  }
}
