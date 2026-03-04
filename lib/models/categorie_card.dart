class CategorieCardModel {
  final String type;
  final String titre;
  CategorieCardModel({required this.type, required this.titre});
}

final List<CategorieCardModel> revenusCategories = [
  CategorieCardModel(type: "Revenu", titre: "Salaire"),
  CategorieCardModel(type: "Revenu", titre: "Aide"),
  CategorieCardModel(type: "Revenu", titre: "Freelance"),
  CategorieCardModel(type: "Revenu", titre: "Remboursement"),
];
final List<CategorieCardModel> depensesCategories = [
  CategorieCardModel(type: "Depense", titre: "Courses"),
  CategorieCardModel(type: "Depense", titre: "Loisirs"),
  CategorieCardModel(type: "Depense", titre: "Transport"),
  CategorieCardModel(type: "Depense", titre: "Abonnement"),
];
