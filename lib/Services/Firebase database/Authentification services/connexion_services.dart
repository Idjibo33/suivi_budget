import 'package:firebase_auth/firebase_auth.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';

class ConnexionServces {
  final AuthServices _authServices = AuthServices();
  //Connecter l'utilisateur
  Future connecterUtilisateur({
    required String email,
    required String password,
  }) async {
    try {
      return await _authServices.firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    }
  }
}
