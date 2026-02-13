import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/inscription_service_provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_dropdown_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_dropdown_provider.dart';
import 'package:suivi_budget/Providers/database_provider.dart';
import 'package:suivi_budget/Providers/utilisateur_provider.dart';
import 'package:suivi_budget/Services/Offline%20database/suivi_budget_database.dart';
import 'package:suivi_budget/views/Authentification/connexion_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialiser la base de données
  await Firebase.initializeApp();
  final database = await SuiviBudgetDatabase.initialiser();
  final dao = database.transactionDao;
  await dotenv.load(fileName: ".env");

  runApp(
    //Déclaration des providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(dao: dao)..lireTransactions(),
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
      home: ConnexionPage(),
    );
  }
}
