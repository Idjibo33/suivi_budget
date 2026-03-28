import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/views/Accueil/accueil_screen.dart';
import 'package:suivi_budget/views/Authentification/connexion_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(child: Text(snapshot.error.toString())),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: const Center(child: CircularProgressIndicator.adaptive()),
            );
          }
          if (snapshot.hasData) {
            return AccueilScreen();
          } else {
            return ConnexionPage();
          }
        },
      ),
    );
  }
}
