import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_navigation.dart';
import 'package:suivi_budget/models/helpers/responsive.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/services/local_auth.dart';
import 'package:suivi_budget/views/accueil/accueil_screen.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/profil/profil_screen.dart';

/// Coque adaptative : barre d'onglets sur téléphone, rail compact sur tablette,
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

  /// Sélection du rail : comportement historique inchangé sur grand écran.
  void selectionner(int index) {
    final EtatNavigation destination = EtatNavigation.depuisIndex(index);
    setState(() => _destination = destination);

    switch (destination) {
      case EtatNavigation.accueil:
        _scaffoldKey.currentState?.closeDrawer();
      case EtatNavigation.budgets:
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (context) => const BudgetsScreen()),
        );
      case EtatNavigation.ajouter:
        naviguerAjouterTransactionPage(context);
      case EtatNavigation.profil:
        _scaffoldKey.currentState?.openDrawer();
    }
  }

  /// Sur mobile, on change d'enfant sans pousser de route : la barre reste
  /// visible et l'accueil conserve son état dans l'`IndexedStack`.
  void selectionnerMobile(int index) {
    setState(() => _destination = EtatNavigation.depuisIndexMobile(index));
  }

  /// Le bouton « Fermer » de l'onglet Profil ramène à l'accueil.
  void revenirAccueil() {
    setState(() => _destination = EtatNavigation.accueil);
  }

  /// Le FAB et le drawer appartiennent au `Scaffold` de l'accueil ; la barre
  /// appartient au `Scaffold` parent, qui réduit la hauteur disponible.
  Widget _coqueMobile(Widget accueil) {
    return Scaffold(
      body: IndexedStack(
        index: _destination.indexMobile,
        children: [
          accueil,
          const BudgetsScreen(),
          ProfilScreen(onFermer: revenirAccueil),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _destination.indexMobile,
        onDestinationSelected: selectionnerMobile,
        destinations: [
          for (final EtatNavigation destination
              in EtatNavigation.destinationsMobile)
            NavigationDestination(
              icon: Icon(destination.icone),
              selectedIcon: Icon(destination.icone),
              label: destination.libelle,
            ),
        ],
      ),
    );
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
          return _coqueMobile(accueil);
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
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Styles.bordure(context),
            ),
            Expanded(child: accueil),
          ],
        );
      },
    );
  }
}
