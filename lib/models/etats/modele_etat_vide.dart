import 'icone_etat_vide.dart';

/// Modèles d'état vide personnalisables, inspirés du prototype validé.
///
/// Le modèle choisi est sérialisé dans la base locale (table `parametres_table`)
/// pour survivre au redémarrage de l'application.
enum PresetEtatVide {
  guide('Guidé'),
  encourageant('Encourageant'),
  minimal('Minimal');

  const PresetEtatVide(this.libelle);

  final String libelle;

  ModeleEtatVide get modele => switch (this) {
        guide => const ModeleEtatVide(
            titre: 'Commencez par une enveloppe',
            corps: 'Créez un budget, puis ajoutez vos transactions pour suivre ce qu’il reste à dépenser.',
            cta: 'Créer un budget',
            icone: IconeEtatVide.idee,
            motif: MotifEtatVide.points,
            preset: guide,
          ),
        encourageant => const ModeleEtatVide(
            titre: 'Chaque petite somme compte',
            corps: 'Ajoutez votre première transaction pour voir votre enveloppe prendre vie.',
            cta: 'Ajouter une transaction',
            icone: IconeEtatVide.graphique,
            motif: MotifEtatVide.hachure,
            preset: encourageant,
          ),
        minimal => const ModeleEtatVide(
            titre: 'Rien pour le moment',
            corps: 'Vos budgets apparaîtront ici dès que vous en créerez un.',
            cta: 'Nouveau budget',
            icone: IconeEtatVide.portefeuille,
            motif: MotifEtatVide.uni,
            preset: minimal,
          ),
      };
}

/// Motif de fond d'un état vide : exprimé par la forme, pas par une couleur.
enum MotifEtatVide {
  uni('Uni'),
  points('Points'),
  hachure('Hachures');

  const MotifEtatVide(this.libelle);

  final String libelle;

  static MotifEtatVide depuisCode(String code) => switch (code) {
        'uni' => uni,
        'points' => points,
        'hachure' => hachure,
        _ => MotifEtatVide.uni,
      };
}

class ModeleEtatVide {
  const ModeleEtatVide({
    required this.titre,
    required this.corps,
    required this.cta,
    required this.icone,
    required this.motif,
    required this.preset,
  });

  static final ModeleEtatVide parDefaut = PresetEtatVide.guide.modele;

  /// État vide de l'onglet « Archivés » : ce n'est pas un modèle personnalisable,
  /// mais il réutilise le même composant pour rester cohérent visuellement.
  static const ModeleEtatVide archivesVides = ModeleEtatVide(
    titre: 'Aucun budget archivé',
    corps: 'Vos enveloppes terminées apparaîtront ici. '
        'Retrouvez vos budgets en cours dès maintenant.',
    cta: 'Voir les budgets en cours',
    icone: IconeEtatVide.portefeuille,
    motif: MotifEtatVide.uni,
    preset: PresetEtatVide.minimal,
  );

  final String titre;
  final String corps;
  final String cta;
  final IconeEtatVide icone;
  final MotifEtatVide motif;
  final PresetEtatVide preset;

  /// Transition nommée : choisir un modèle remplace tous les champs.
  ModeleEtatVide appliquerPreset(PresetEtatVide nouveau) => nouveau.modele;

  /// Transition nommée : changer uniquement l'icône affichée.
  ModeleEtatVide changerIcone(IconeEtatVide nouvelIcone) =>
      personnaliser(icone: nouvelIcone);

  /// Personnalisation libre, le nom du modèle d'origine reste affiché.
  ModeleEtatVide personnaliser({
    String? titre,
    String? corps,
    String? cta,
    IconeEtatVide? icone,
    MotifEtatVide? motif,
  }) =>
      ModeleEtatVide(
        titre: titre ?? this.titre,
        corps: corps ?? this.corps,
        cta: cta ?? this.cta,
        icone: icone ?? this.icone,
        motif: motif ?? this.motif,
        preset: preset,
      );

  Map<String, dynamic> toJson() => {
        'titre': titre,
        'corps': corps,
        'cta': cta,
        'icone': icone.code,
        'motif': motif.name,
        'preset': preset.name,
      };

  factory ModeleEtatVide.depuisJson(Map<String, dynamic> json) {
    final PresetEtatVide preset = PresetEtatVide.values.firstWhere(
      (value) => value.name == json['preset'],
      orElse: () => PresetEtatVide.guide,
    );
    return ModeleEtatVide(
      titre: (json['titre'] as String?)?.trim().isNotEmpty == true
          ? json['titre'] as String
          : preset.modele.titre,
      corps: (json['corps'] as String?) ?? preset.modele.corps,
      cta: (json['cta'] as String?)?.trim().isNotEmpty == true
          ? json['cta'] as String
          : preset.modele.cta,
      icone: IconeEtatVide.depuisCode(
        (json['icone'] as String?) ?? preset.modele.icone.code,
      ),
      motif: MotifEtatVide.depuisCode((json['motif'] as String?) ?? 'uni'),
      preset: preset,
    );
  }
}
