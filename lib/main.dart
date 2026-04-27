import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Core/get_it.dart';
import 'package:suivi_budget/shared/local_auth_provider.dart';
import 'package:suivi_budget/shared/navigation_widget.dart';
import 'package:suivi_budget/Providers/Auth%20provider/auth_provider.dart';
import 'package:suivi_budget/Features/transactions/logic/providers/database_provider.dart';
import 'package:suivi_budget/Providers/modification_view_provider.dart/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/Features/transactions/data/services/transaction_database.dart';
import 'package:suivi_budget/Core/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = await TransactionDatabase.intialize();
  final database = db.transactionDao;
  locator();
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
        ChangeNotifierProvider(create: (context) => LocalAuthProvider()),
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: couleurRevenu,
          brightness: Brightness.light,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: NavigationWidget(),
    );
  }
}
