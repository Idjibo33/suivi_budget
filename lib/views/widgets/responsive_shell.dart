import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_navigation.dart';
import 'package:suivi_budget/models/helpers/responsive.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/services/local_auth.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';

/// Coque adaptative : téléphone inchangé, rail compact sur tablette,
/// rail étendu sur desktop et fenêtres larges.
class ResponsiveShell extends StatefulWidget {
  /// Injectable pour les tests ; l'application utilise la biométrie réelle.
  final LocalAuth? localAuth;

  const ResponsiveShell({super.key, this.localAuth});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  EtatNavigation _destination = EtatNavigation.accueil;

  void selectionner(int index) {
    final EtatNavigation destination = EtatNavigation.depuisIndex(index);
    setState(() => _destination = destination);

    switch (destination) {
      case EtatNavigation.accueil:
        _scaffoldKey.currentState?.closeDrawer();
      case EtatNavigation.ajouter:
        naviguerAjouterTransactionPage(context);
      case EtatNavigation.profil:
        _scaffoldKey.currentState?.openDrawer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget accueil = AccueilScreen(
      key: const ValueKey('accueil_shell'),
      localAuth: widget.localAuth,
      scaffoldKey: _scaffoldKey,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Responsive.mobileMax) {
          return accueil;
        }

        final bool etendu = constraints.maxWidth >= Responsive.tableauMax;
        return Row(
          children: [
            NavigationRail(
              extended: etendu,
              backgroundColor: Styles.surfaceSecondaire(context),
              selectedIndex: _destination.index,
              onDestinationSelected: selectionner,
              labelType: etendu
                  ? NavigationRailLabelType.none
                  : NavigationRailLabelType.selected,
              destinations: [
                for (final EtatNavigation destination in EtatNavigation.values)
                  NavigationRailDestination(
                    icon: Icon(destination.icone),
                    selectedIcon: Icon(destination.icone),
                    label: Text(destination.libelle),
                  ),
              ],
            ),
            VerticalDivider(width: 1, thickness: 1, color: Styles.bordure(context)),
            Expanded(child: accueil),
          ],
        );
      },
    );
  }
}
