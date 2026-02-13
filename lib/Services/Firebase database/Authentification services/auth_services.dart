import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Stream<User?> get authStateChange => firebaseAuth.authStateChanges();
  User? get currentUser => firebaseAuth.currentUser;
}
