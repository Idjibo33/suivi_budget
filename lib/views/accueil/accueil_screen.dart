import 'package:suivi_budget/models/etats/etat_onglet_transaction.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/services/local_auth.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_authentification.dart';
import 'package:suivi_budget/models/etats/saveur_application.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/views/accueil/widgets/section_enveloppes.dart';
import 'package:suivi_budget/views/budgets/budgets_screen.dart';
import 'package:suivi_budget/views/profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/views/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/views/widgets/liste_transactions_sheet.dart';
import 'package:suivi_budget/views/widgets/max_width_container.dart';
import 'package:suivi_budget/views/widgets/solde_widget.dart';

class AccueilScreen extends StatefulWidget {
  /// Injectable pour les tests ; l'application utilise la biométrie réelle.
  final LocalAuth? localAuth;

  /// Clé optionnelle pour ouvrir le profil depuis la navigation responsive.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const AccueilScreen({super.key, this.localAuth, this.scaffoldKey});

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
              FilledButton(
                onPressed: reessayer,
                child: const Text("Réessayer"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget ecranPrincipal(BuildContext context) {
    final double largeurEcran = MediaQuery.sizeOf(context).width;
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: Drawer(
        width: largeurEcran < 600 ? double.infinity : 420.0,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Row(
                  children: [
                    const CustomLogoWidget(padding: 8.0, size: 20),
                    const Gap(10),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          saveurApplication.nomAffiche,
                          style: Styles.texteEnTete,
                        ),
                      ),
                    ),
                    if (largeurEcran >= 600)
                      IconButton(
                        tooltip: 'Budgets',
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (context) => const BudgetsScreen(),
                          ),
                        ),
                        icon: const Icon(Icons.pie_chart_outline),
                        style: IconButton.styleFrom(
                          backgroundColor: Styles.surfaceSecondaire(context),
                        ),
                      ),
                    if (largeurEcran >= 600)
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SoldeWidget(),
                      ),
                      const Gap(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: LayoutBuilder(
                          builder: (context, contraintes) {
                            final largeur = contraintes.maxWidth;
                            final boutonsCoteACote =
                                largeur >=
                                380 * MediaQuery.textScalerOf(context).scale(1);
                            final largeurBouton = boutonsCoteACote
                                ? (largeur - 10) / 2
                                : largeur;
                            return Wrap(
                              spacing: 10,
                              runSpacing: 8,
                              children: [
                                SizedBox(
                                  width: largeurBouton,
                                  child: FilledButton.icon(
                                    onPressed: () =>
                                        naviguerAjouterTransactionPage(
                                          context,
                                          initial:
                                              EtatOngletTransaction.depense,
                                        ),
                                    icon: const Icon(Icons.arrow_downward),
                                    label: const Text('Ajouter une dépense'),
                                  ),
                                ),
                                SizedBox(
                                  width: largeurBouton,
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        naviguerAjouterTransactionPage(
                                          context,
                                          initial: EtatOngletTransaction.revenu,
                                        ),
                                    icon: const Icon(Icons.arrow_upward),
                                    label: const Text('Ajouter un revenu'),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      const Gap(24),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SectionEnveloppes(),
                      ),
                      const Gap(24),
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
                                  "Transactions récentes",
                                  style: Styles.texteTitre,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () =>
                                  ListeTransactionsSheet.afficher(context),
                              child: const Text("Voir tout"),
                            ),
                          ],
                        ),
                      ),
                      const Gap(4),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          height: 320,
                          child: ListTransactionsWidgets(),
                        ),
                      ),
                    ],
                  ),
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
