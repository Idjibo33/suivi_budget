class ModeleBudget {
  const ModeleBudget({
    required this.nom,
    this.plafond,
    this.periodeLibre = false,
    this.depassementAutorise = false,
  });

  static const suggestions = [
    ModeleBudget(nom: 'Courses'),
    ModeleBudget(nom: 'Transport'),
    ModeleBudget(nom: 'Loisirs'),
  ];

  final String nom;
  final int? plafond;
  final bool periodeLibre;
  final bool depassementAutorise;

  Map<String, Object?> toJson() => {
    'nom': nom,
    'plafond': plafond,
    'periodeLibre': periodeLibre,
    'depassementAutorise': depassementAutorise,
  };

  factory ModeleBudget.depuisJson(Map<String, dynamic> json) => ModeleBudget(
    nom: json['nom'] as String,
    plafond: json['plafond'] as int?,
    periodeLibre: json['periodeLibre'] as bool,
    depassementAutorise: json['depassementAutorise'] as bool,
  );
}
