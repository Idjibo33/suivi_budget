import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/helpers/repartition.dart';

import 'fixtures/fakes.dart';

void main() {
  final categories = [
    Categorie(id: 1, nom: 'Alimentation', type: 'Depense', famille: 'Essentiel'),
    Categorie(id: 2, nom: 'Loisirs', type: 'Depense', famille: 'Style de vie'),
    Categorie(id: 3, nom: 'Salaire', type: 'Revenu', famille: 'Revenus'),
  ];

  test('la répartition ne retient que les dépenses', () {
    final lignes = repartitionParCategorie(
      transactions: [
        buildTransaction(
          montant: 8000,
          categorieId: 1,
          type: 'Depense',
        ),
        buildTransaction(
          montant: 2000,
          categorieId: 2,
          type: 'Depense',
        ),
        buildTransaction(
          montant: 50000,
          categorieId: 3,
          type: 'Revenu',
        ),
      ],
      categories: categories,
    );

    expect(lignes.map((ligne) => ligne.famille), [
      'Essentiel',
      'Style de vie',
    ]);
    expect(lignes.map((ligne) => ligne.montant), [8000, 2000]);
  });

  test('une catégorie inconnue est regroupée sous Autre', () {
    final lignes = repartitionParCategorie(
      transactions: [
        buildTransaction(montant: 1500, categorieId: 99, type: 'Depense'),
      ],
      categories: categories,
    );

    expect(lignes.single.famille, 'Autre');
  });
}
