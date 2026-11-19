import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:suivi_budget/Services/Local%20Auth/local_auth.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/navigation/naviguer_ajouter_transaction_page.dart';
import 'package:suivi_budget/views/Profil/profil_screen.dart';
import 'package:suivi_budget/views/widgets/custom_logo_widget.dart';
import 'package:suivi_budget/views/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/views/widgets/max_width_container.dart';
import 'package:suivi_budget/views/widgets/solde_widget.dart';

class AccueilScreen extends StatefulWidget {
  final LocalAuth? localAuth;
  const AccueilScreen({super.key, this.localAuth});

  @override
  State<AccueilScreen> createState() => _AccueilScreenState();
}

class _AccueilScreenState extends State<AccueilScreen> {
  late final LocalAuth localAuth = widget.localAuth ?? LocalAuth();
  bool verificationEnCours = true;
  bool authentifie = false;

  @override
  void initState() {
    super.initState();
    authentifier();
  }

  Future<void> authentifier() async {
    final bool resultat = kIsWeb
        ? true
        : await localAuth.authenticated(
            description: "Authentifiez-vous pour continuer",
          );
    if (!mounted) {
      return;
    }
    setState(() {
      authentifie = resultat;
      verificationEnCours = false;
    });
  }

  void reessayer() {
    setState(() {
      verificationEnCours = true;
    });
    authentifier();
  }

  Widget ecranVerrouille() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 48),
              const Gap(16),
              Text(
                "Authentification requise",
                style: Styles.texteTitre,
                textAlign: TextAlign.center,
              ),
              const Gap(8),
              Text(
                "Impossible de vérifier votre identité sur cet appareil.",
                style: Styles.texteCorps,
                textAlign: TextAlign.center,
              ),
              const Gap(16),
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

  @override
  Widget build(BuildContext context) {
    if (verificationEnCours) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!authentifie) {
      return ecranVerrouille();
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Styles.couleurbgSecondaire,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(30),
        ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const CustomLogoWidget(padding: 7.0, size: 25),
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
                        ],
                      ),
                    ),
                    Builder(
                      builder: (context) => GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: CircleAvatar(
                          backgroundColor: Styles.couleurbgSecondaire,
                          child: const Icon(Icons.person_2_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: SoldeWidget(),
              ),
              const Gap(12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {},
                          child: Text("voir tout", style: Styles.texteTitre),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ListTransactionsWidgets(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
