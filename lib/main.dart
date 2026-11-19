import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Auth%20provider/auth_provider.dart';
import 'package:suivi_budget/Providers/Database%20provider/database_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/Services/database/database_factory.dart';
import 'package:suivi_budget/Services/database/transaction_database.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Accueil/accueil_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDatabaseFactory();
  Intl.defaultLocale = 'fr_FR';
  await initializeDateFormatting('fr_FR');
  final db = await TransactionDatabase.initialize();
  final database = db.transactionDao;

  runApp(
    //Les providers
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ModifierTransactionViewProvider(),
        ),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(
          create: (context) =>
              DatabaseProvider(database: database)..listenTransactions(),
        ),
      ],
      child: const MainApp(),
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
      home: const AccueilScreen(),
    );
  }
}
