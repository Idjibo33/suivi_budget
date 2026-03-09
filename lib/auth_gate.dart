import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Supabase%20authentification%20services%20provider/auth_provider.dart';
import 'package:suivi_budget/views/Accueil/accueil_screen.dart';
import 'package:suivi_budget/views/Authentification/connexion_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthServicesProvider>(
        builder: (context, value, child) => StreamBuilder(
          stream: value.supabase.authState(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator.adaptive()),
              );
            }
            if (snapshot.hasData) {
              final AuthChangeEvent event = snapshot.data!.event;
              switch (event) {
                case AuthChangeEvent.signedIn:
                  return const AccueilScreen();
                case AuthChangeEvent.signedOut:
                  return const ConnexionPage();
                default:
                  ConnexionPage();
              }
              return const ConnexionPage();
            }
            return const ConnexionPage();
          },
        ),
      ),
    );
  }
}
