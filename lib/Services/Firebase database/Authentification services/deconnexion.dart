import 'package:firebase_auth/firebase_auth.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth.dart';

class DeconnexionService {
  final Auth authServices = Auth();
  // Deconnecter l'utilisateur
  Future deconnecterUtilisateur() async {
    try {
      return await authServices.firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }
}
