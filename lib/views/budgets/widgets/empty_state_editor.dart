import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/icone_etat_vide.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/budgets/widgets/empty_state_card.dart';

/// Éditeur du modèle d'état vide : presets, champs libres et aperçu en direct.
class EmptyStateEditor extends StatefulWidget {
  const EmptyStateEditor({super.key});

  @override
  State<EmptyStateEditor> createState() => _EmptyStateEditorState();
}

class _EmptyStateEditorState extends State<EmptyStateEditor> {
  late ModeleEtatVide _modele;
  late final TextEditingController _titre;
  late final TextEditingController _corps;
  late final TextEditingController _cta;

  @override
  void initState() {
    super.initState();
    _modele = context.read<DatabaseProvider>().modeleEtatVide;
    _titre = TextEditingController(text: _modele.titre);
    _corps = TextEditingController(text: _modele.corps);
    _cta = TextEditingController(text: _modele.cta);
  }

  @override
  void dispose() {
    _titre.dispose();
    _corps.dispose();
    _cta.dispose();
    super.dispose();
  }

  void appliquerPreset(PresetEtatVide preset) {
    final ModeleEtatVide nouveau = _modele.appliquerPreset(preset);
    setState(() {
      _modele = nouveau;
      _titre.text = nouveau.titre;
      _corps.text = nouveau.corps;
      _cta.text = nouveau.cta;
    });
  }

  void personnaliser() {
    setState(() {
      _modele = _modele.personnaliser(
        titre: _titre.text.trim(),
        corps: _corps.text.trim(),
        cta: _cta.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Personnaliser l’état vide'),
      content: SizedBox(
        // Largeur finie même sur mobile : le dialogue la borne à l'écran,
        // évitant un calcul de dimensions intrinsèques dans le bottom sheet.
        width: 620.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  for (final preset in PresetEtatVide.values)
                    ChoiceChip(
                      label: Text(preset.libelle),
                      selected: _modele.preset == preset,
                      onSelected: (_) => appliquerPreset(preset),
                    ),
                ],
              ),
              const Gap(16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool large = constraints.maxWidth >= 560;
                  final Widget formulaire = Column(
                    children: [
                      TextField(
                        controller: _titre,
                        decoration: const InputDecoration(labelText: 'Titre'),
                        onChanged: (_) => personnaliser(),
                      ),
                      const Gap(10),
                      TextField(
                        controller: _corps,
                        maxLines: 3,
                        decoration: const InputDecoration(labelText: 'Texte'),
                        onChanged: (_) => personnaliser(),
                      ),
                      const Gap(10),
                      TextField(
                        controller: _cta,
                        decoration: const InputDecoration(labelText: 'Bouton'),
                        onChanged: (_) => personnaliser(),
                      ),
                      const Gap(10),
                      DropdownButtonFormField<IconeEtatVide>(
                        initialValue: _modele.icone,
                        decoration: const InputDecoration(labelText: 'Icône'),
                        items: [
                          for (final icone in IconeEtatVide.values)
                            DropdownMenuItem(
                              value: icone,
                              child: Text(icone.libelle),
                            ),
                        ],
                        onChanged: (valeur) => setState(
                          () => _modele = _modele.changerIcone(valeur!),
                        ),
                      ),
                      const Gap(10),
                      DropdownButtonFormField<MotifEtatVide>(
                        initialValue: _modele.motif,
                        decoration: const InputDecoration(
                          labelText: 'Motif de fond',
                        ),
                        items: [
                          for (final motif in MotifEtatVide.values)
                            DropdownMenuItem(
                              value: motif,
                              child: Text(motif.libelle),
                            ),
                        ],
                        onChanged: (valeur) => setState(
                          () => _modele = _modele.personnaliser(motif: valeur),
                        ),
                      ),
                    ],
                  );
                  final Widget apercu = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aperçu',
                        style: Styles.texteCorps.copyWith(
                          color: Styles.texteSecondaire(context),
                        ),
                      ),
                      const Gap(6),
                      EmptyStateCard(modele: _modele),
                    ],
                  );
                  return Flex(
                    direction: large ? Axis.horizontal : Axis.vertical,
                    mainAxisSize: large ? MainAxisSize.max : MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (large)
                        Expanded(child: formulaire)
                      else
                        Flexible(child: formulaire),
                      if (large) const Gap(16),
                      if (large)
                        Expanded(child: apercu)
                      else
                        Flexible(child: apercu),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () async {
            final bool reussi = await context
                .read<DatabaseProvider>()
                .enregistrerModeleEtatVide(context, modele: _modele);
            if (reussi && context.mounted) {
              Navigator.pop(context);
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
