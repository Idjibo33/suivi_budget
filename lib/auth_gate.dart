import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/auth_provider.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';
import 'package:suivi_budget/views/authentification/connexion_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, value, child) => StreamBuilder(
          stream: Stream.empty(),
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
