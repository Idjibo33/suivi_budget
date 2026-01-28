import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_dropdown_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_dropdown_provider.dart';
import 'package:suivi_budget/Services/suivi_budget_database.dart';
import 'package:suivi_budget/features/Accueil/accueil_screen.dart';
import 'package:suivi_budget/Providers/database_provider.dart';
import 'package:suivi_budget/Providers/utilisateur_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //Initialiser la base de données
  final database = await SuiviBudgetDatabase.initialiser();
  final dao = database.transactionDao;

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
      home: AccueilScreen(),
    );
  }
}
