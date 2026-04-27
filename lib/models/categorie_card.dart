import 'package:equatable/equatable.dart';

class CategorieCardModel extends Equatable {
  final String type;
  final String titre;
  const CategorieCardModel({required this.type, required this.titre});

  @override
  List<Object?> get props => [type, titre];
}

const List<CategorieCardModel> revenusCategories = [
  CategorieCardModel(type: "Revenu", titre: "Salaire"),
  CategorieCardModel(type: "Revenu", titre: "Aide"),
  CategorieCardModel(type: "Revenu", titre: "Freelance"),
  CategorieCardModel(type: "Revenu", titre: "Remboursement"),
];
const List<CategorieCardModel> depensesCategories = [
  CategorieCardModel(type: "Depense", titre: "Courses"),
  CategorieCardModel(type: "Depense", titre: "Loisirs"),
  CategorieCardModel(type: "Depense", titre: "Transport"),
  CategorieCardModel(type: "Depense", titre: "Abonnement"),
];
