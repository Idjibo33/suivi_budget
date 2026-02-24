import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/auth_provider.dart';
import 'package:suivi_budget/views/Accueil/accueil_screen.dart';
import 'package:suivi_budget/views/Authentification/connexion_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, value, child) => StreamBuilder(
          stream: value.authServices.authStateChange,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return AccueilScreen();
            } else {
              return ConnexionPage();
            }
          },
        ),
      ),
    );
  }
}
