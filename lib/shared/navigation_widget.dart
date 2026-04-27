import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:suivi_budget/Features/Accueil/presentation/widgets/floating_button.dart';
import 'package:suivi_budget/Features/chart/presentation/screens/chart_screen.dart';
import 'package:suivi_budget/Features/Accueil/presentation/Screens/accueil_screen.dart';
import 'package:suivi_budget/shared/local_auth_provider.dart';

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
    final authentication = await context
        .read<LocalAuthProvider>()
        .authenticate();
    if (!authentication) {
      exit(0);
    }
  }

  static const List<Widget> pages = [AccueilScreen(), ChartScreen()];
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingButton(),
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
