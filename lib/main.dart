import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suivi_budget/Providers/Firebase%20authentification%20service%20providers/auth_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_utilisateur_provider.dart';
import 'package:suivi_budget/Providers/Preferences%20provider/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_provider.dart';
import 'package:suivi_budget/auth_gate.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Charger les preferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.getStringList("Infos Utilisateur");

  runApp(
    //Les providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              DocTransactionProvider()..subscribeTransactions(),
        ),

        ChangeNotifierProvider(
          create: (context) => RevenusCategoriesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DepensesCategoriesProvider(),
        ),

        ChangeNotifierProvider(create: (context) => AuthServicesProvider()),
        ChangeNotifierProvider(create: (context) => DocUtilisateurProvider()),
        ChangeNotifierProvider(
          create: (context) => UtilisateurPreferencesProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ModifierTransactionViewProvider(),
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
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Styles.couleurRevenu),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
