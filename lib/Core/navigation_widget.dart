import 'dart:io';

import 'package:flutter/material.dart';
import 'package:suivi_budget/Features/Historique/historique_screen.dart';
import 'package:suivi_budget/Services/Local%20Auth/local_auth.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/Features/Accueil/accueil_screen.dart';

class NavigationWidget extends StatefulWidget {
  const NavigationWidget({super.key});

  @override
  State<NavigationWidget> createState() => _NavigationWidgetState();
}

class _NavigationWidgetState extends State<NavigationWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    authenticate();
  }

  void authenticate() async {
    final authentication = await LocalAuth().authenticated(
      description: "Authentifier-vous pour continuer",
    );
    if (!authentication) {
      exit(0);
    }
  }

  static const List<Widget> pages = [AccueilScreen(), HistoriqueScreen()];
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages.elementAt(selectedPage),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(30),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: (value) {
            setState(() {
              selectedPage = value;
            });
          },
          currentIndex: selectedPage,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Accueil"),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: "Historique",
            ),
          ],
        ),
      ),
    );
  }
}
