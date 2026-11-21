import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_theme.dart';
import 'package:suivi_budget/models/etats/saveur_application.dart';
import 'package:suivi_budget/providers/theme_provider.dart';
import 'package:suivi_budget/views/widgets/head_text_widget.dart';

/// Page de profil affichée dans le tiroir de l'accueil.
///
/// Elle rassemble l'identité locale, le choix d'apparence et les informations
/// de confidentialité, sans bouton sans action.
class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = context.watch<ThemeProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                headTextWidget(texte: "Profil"),
                IconButton(
                  tooltip: 'Fermer',
                  onPressed: () => Scaffold.of(context).closeDrawer(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Gap(24),
            const _CarteIdentite(),
            const Gap(24),
            _Section(
              titre: 'Apparence',
              icone: Icons.palette_outlined,
              enfant: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Choisissez l’apparence de l’application.',
                    style: Styles.texteCorps.copyWith(
                      color: Styles.texteSecondaire(context),
                    ),
                  ),
                  const Gap(12),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: SegmentedButton<ModeTheme>(
                      segments: [
                        for (final ModeTheme mode in ModeTheme.values)
                          ButtonSegment<ModeTheme>(
                            value: mode,
                            label: Text(mode.libelle),
                            icon: Icon(mode.icone, size: 18),
                          ),
                      ],
                      selected: {theme.mode},
                      onSelectionChanged: (Set<ModeTheme> selection) =>
                          theme.choisir(selection.first),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(16),
            _Section(
              titre: 'Sécurité',
              icone: Icons.fingerprint,
              enfant: _LigneInfo(
                icone: Icons.lock_outline,
                titre: 'Verrouillage par empreinte',
                description:
                    'Utilisé uniquement si l’appareil prend en charge la biométrie.',
              ),
            ),
            const Gap(16),
            _Section(
              titre: 'À propos',
              icone: Icons.info_outline,
              enfant: Column(
                children: [
                  _LigneInfo(
                    icone: Icons.save_outlined,
                    titre: 'Stockage local',
                    description: 'Vos données restent sur cet appareil.',
                  ),
                  const Gap(12),
                  _LigneInfo(
                    icone: Icons.brightness_auto,
                    titre: 'Thèmes',
                    description: 'Clair, sombre ou selon le système.',
                  ),
                ],
              ),
            ),
            const Gap(24),
            Center(
              child: Text(
                saveurApplication.nomAffiche,
                style: Styles.texteCorps.copyWith(
                  color: Styles.texteSecondaire(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CarteIdentite extends StatelessWidget {
  const _CarteIdentite();

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Styles.surfaceSecondaire(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: couleurs.primaryContainer,
            child: Icon(
              Icons.person_outline,
              size: 38,
              color: couleurs.onPrimaryContainer,
            ),
          ),
          const Gap(14),
          Text(
            'Utilisateur local',
            style: Styles.texteEnTete.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const Gap(4),
          Text(
            'Données conservées sur cet appareil',
            style: Styles.texteCorps.copyWith(
              color: Styles.texteSecondaire(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String titre;
  final IconData icone;
  final Widget enfant;

  const _Section({
    required this.titre,
    required this.icone,
    required this.enfant,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Styles.bordure(context)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icone, size: 20, color: couleurs.primary),
              const Gap(10),
              Text(titre, style: Styles.texteTitre),
            ],
          ),
          const Gap(14),
          enfant,
        ],
      ),
    );
  }
}

class _LigneInfo extends StatelessWidget {
  final IconData icone;
  final String titre;
  final String description;

  const _LigneInfo({
    required this.icone,
    required this.titre,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 20, color: Styles.texteSecondaire(context)),
        const Gap(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titre, style: Styles.texteTitre.copyWith(fontSize: 14)),
              const Gap(2),
              Text(
                description,
                style: Styles.texteCorps.copyWith(
                  fontSize: 12,
                  color: Styles.texteSecondaire(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
