import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Database%20services%20provider/transaction_table_provider.dart';
import 'package:suivi_budget/Providers/Database%20services%20provider/utilisateur_table_provider.dart';
import 'package:suivi_budget/Providers/Preferences/utilisateur_preferences_provider.dart';
import 'package:suivi_budget/Providers/Supabase%20authentification%20services%20provider/auth_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/auth_gate.dart';
import 'package:suivi_budget/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
    url: dotenv.env['URL'] ?? '',
    anonKey: dotenv.env['ANONKEY'] ?? '',
  );

  runApp(
    //Les providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModifierTransactionViewProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AuthServicesProvider()),
        ChangeNotifierProvider(create: (context) => UtilisateurTableProvider()),
        ChangeNotifierProvider(create: (context) => TransactionTableProvider()),
        ChangeNotifierProvider(
          create: (context) => UtilisateurPreferencesProvider(),
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
