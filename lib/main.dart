import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/auth_provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/providers/theme_provider.dart';
import 'package:suivi_budget/services/database/database_factory.dart';
import 'package:suivi_budget/services/database/transaction_database.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';

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
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
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
    final ThemeMode themeMode = context.watch<ThemeProvider>().themeMode;

    return MaterialApp(
      theme: AppTheme.clair,
      darkTheme: AppTheme.sombre,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: const AccueilScreen(),
    );
  }
}
