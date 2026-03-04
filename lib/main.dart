import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Auth%20provider/auth_provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/solde_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Accueil/accueil_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    //Les providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SoldeProvider()),
        ChangeNotifierProvider(
          create: (context) => ModifierTransactionViewProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
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
      home: AccueilScreen(),
    );
  }
}
