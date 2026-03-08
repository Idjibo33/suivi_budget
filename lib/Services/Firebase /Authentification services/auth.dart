import 'package:firebase_auth/firebase_auth.dart';
import 'package:suivi_budget/models/helpers.dart';

class Firebase implements AuthServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => auth.authStateChanges();
  User? get currentUser => auth.currentUser;

  @override
  Future<UserCredential> createAccountWithEmail(
    String email,
    String password,
  ) async {
    return await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future<UserCredential> signInAnonymously() async {
    return await auth.signInAnonymously();
  }

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  @override
  Future signOut() {
    return auth.signOut();
  }
}
