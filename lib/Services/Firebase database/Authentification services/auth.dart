import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();
  User? get currentUser => firebaseAuth.currentUser;
}
