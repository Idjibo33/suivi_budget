import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/services/local_auth.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_authentification.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/views/profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/views/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/views/widgets/max_width_container.dart';
import 'package:suivi_budget/views/widgets/solde_widget.dart';

class AccueilScreen extends StatefulWidget {
  /// Injectable pour les tests ; l'application utilise la biométrie réelle.
  final LocalAuth? localAuth;

  const AccueilScreen({super.key, this.localAuth});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  late final LocalAuth localAuth = widget.localAuth ?? LocalAuth();

  EtatAuthentification _etat = demarrerAuthentification(
    contournerVerification: kIsWeb,
  );

  @override
  void initState() {
    super.initState();
    verifierDisponibilite();
  }

  /// Ouvre l'accueil directement si l'appareil ne peut pas authentifier.
  Future<void> verifierDisponibilite() async {
    if (kIsWeb) {
      return;
    }
    final bool disponible = await localAuth.estUtilisable();
    if (!mounted) {
      return;
    }
    if (!disponible) {
      setState(() => _etat = resultatDisponibiliteBiometrie(false));
      return;
    }
    await authentifier();
  }

  Future<void> authentifier() async {
    setState(() => _etat = const EtatAuthentificationVerification());
    final bool resultat = await localAuth.authenticated(
      description: "Authentifiez-vous pour continuer",
      verifierDisponibilite: false,
    );
    if (!mounted) {
      return;
    }
    setState(() => _etat = resultatAuthentification(resultat));
  }

  void reessayer() => verifierDisponibilite();

  Widget ecranVerrouille() {
    final ColorScheme couleurs = Theme.of(context).colorScheme;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 40, color: couleurs.primary),
              const Gap(20),
              Text(
                "Authentification requise",
                style: Styles.texteEnTete,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                "Impossible de vérifier votre identité sur cet appareil.",
                style: Styles.texteCorps.copyWith(
                  color: Styles.texteSecondaire(context),
                ),
                textAlign: TextAlign.center,
              ),
              const Gap(24),
              FilledButton(onPressed: reessayer, child: const Text("Réessayer")),
            ],
          ),
        ),
      ),
    );
  }

  Widget ecranPrincipal(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => naviguerAjouterTransactionPage(context),
        child: const Icon(Icons.add),
      ),
      drawer: Drawer(
        width: double.infinity,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: ProfilScreen(),
        ),
      ),
      body: SafeArea(
        child: MaxWidthContainer(
          child: Column(
            key: const ValueKey('home_content'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  children: [
                    const CustomLogoWidget(padding: 8.0, size: 20),
                    const Gap(10),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Suivi budget",
                          style: Styles.texteEnTete,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) => IconButton(
                        tooltip: 'Profil',
                        onPressed: () => Scaffold.of(context).openDrawer(),
                        icon: const Icon(Icons.person_outline),
                        style: IconButton.styleFrom(
                          backgroundColor: Styles.surfaceSecondaire(context),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SoldeWidget(),
              ),
              const Gap(28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Transactions récents",
                          style: Styles.texteTitre,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text("voir tout"),
                    ),
                  ],
                ),
              ),
              const Gap(4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTransactionsWidgets(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return switch (_etat) {
      EtatAuthentificationVerification() => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      EtatAuthentificationRefusee() => ecranVerrouille(),
      EtatAuthentificationIgnoree() => ecranPrincipal(context),
      EtatAuthentificationAccordee() => ecranPrincipal(context),
    };
  }
}
