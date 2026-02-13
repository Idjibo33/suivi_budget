import 'package:firebase_auth/firebase_auth.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';

class InscriptionService {
  final AuthServices _authServices = AuthServices();
  // Inscire l'utilisateur avec l'email et le mot de passe
  Future<UserCredential?> inscrireUtilisateur({
    required String email,
    required String password,
  }) async {
    try {
      return await _authServices.firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }
}
