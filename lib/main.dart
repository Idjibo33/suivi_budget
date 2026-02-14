import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/auth_service_provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/connexion_service_provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/deconnexion_services_provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/inscription_service_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_service_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_utilisateur_provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_dropdown_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_dropdown_provider.dart';
import 'package:suivi_budget/Providers/utilisateur_provider.dart';
import 'package:suivi_budget/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialiser la base de données
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(
    //Déclaration des providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DocTransactionServiceProvider(),
        ),

        ChangeNotifierProvider(
          create: (context) => UtilisateurProvider()..initialiserNom(),
        ),
        ChangeNotifierProvider(
          create: (context) => RevenusCategoriesDropdownProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DepensesCategoriesDropdownProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => InscriptionServiceProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AuthServiceProvider()),
        ChangeNotifierProvider(create: (context) => ConnexionServiceProvider()),
        ChangeNotifierProvider(
          create: (context) => DeconnexionServicesProvider(),
        ),
        ChangeNotifierProvider(create: (context) => DocUtilisateurProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
