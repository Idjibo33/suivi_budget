import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/database/suivi_budget_database.dart';
import 'package:suivi_budget/ecran/accueil.dart';
import 'package:suivi_budget/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await SuiviBudgetDatabase.initialiser();
  final dao = database.transactionDao;
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseProvider(dao: dao)),
        ChangeNotifierProvider(
          create: (context) => DatabaseProvider(dao: dao)..lireTransactions(),
        ),
        ChangeNotifierProvider(
          create: (context) => UtilisateurInfoProvider()..lireNom(),
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
      home: Accueil(),
    );
  }
}
