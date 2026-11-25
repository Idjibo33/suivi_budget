import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/categories_par_defaut.dart';
import 'package:suivi_budget/models/etats/choix_periode_budget.dart';
import 'package:suivi_budget/models/etats/icone_etat_vide.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/models/etats/onglet_analyse.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';
import 'package:suivi_budget/models/etats/selection_modification_transaction.dart';
import 'package:suivi_budget/models/helpers/repartition.dart';

import 'fixtures/fakes.dart';

void main() {
  group('modèles corrigés après revue', () {
    test('l’icône d’état vide est un type explicite sérialisé', () {
      final ModeleEtatVide modele = PresetEtatVide.encourageant.modele
          .changerIcone(IconeEtatVide.crayon);

      expect(modele.icone, IconeEtatVide.crayon);
      expect(modele.toJson()['icone'], 'edit');
      final ModeleEtatVide relu = ModeleEtatVide.depuisJson(modele.toJson());
      expect(relu.icone, IconeEtatVide.crayon);
      expect(IconeEtatVide.depuisCode('spark'), IconeEtatVide.idee);
    });

    test('l’état vide des archives est un modèle dédié', () {
      final ModeleEtatVide modele = ModeleEtatVide.archivesVides;

      expect(modele.titre, 'Aucun budget archivé');
      expect(modele.cta, 'Voir les budgets en cours');
      expect(modele.icone, IconeEtatVide.portefeuille);
      expect(modele.preset, PresetEtatVide.minimal);
    });

    test('le choix de période est un type explicite', () {
      final PeriodeBudget periode = const PeriodeMensuelle().changerPeriode(
        choix: ChoixPeriodeBudget.libre,
        debut: '2026-11-01',
        fin: '2026-11-30',
      );

      expect(periode, isA<PeriodeLibre>());
      expect(
        const PeriodeMensuelle().changerPeriode(
          choix: ChoixPeriodeBudget.mensuel,
        ),
        isA<PeriodeMensuelle>(),
      );
    });

    test('une période incohérente ne fait pas planter la lecture', () {
      final Budget budget = Budget(
        nom: 'Ancien',
        alloue: 1000,
        typePeriode: 'libre',
      );

      expect(budget.periodeValide, isNull);
    });

    test('la modification rafraîchit updated_at sans toucher created_at', () {
      final categorie = Categorie(
        id: 1,
        nom: 'Courses',
        createdAt: '2026-01-01T00:00:00.000',
        updatedAt: '2026-01-01T00:00:00.000',
      );
      final budget = Budget(
        id: 1,
        nom: 'Maison',
        alloue: 1000,
        createdAt: '2026-01-01T00:00:00.000',
        updatedAt: '2026-01-01T00:00:00.000',
      );

      expect(
        categorie.avecHorodatageMiseAJour().createdAt,
        categorie.createdAt,
      );
      expect(
        categorie.avecHorodatageMiseAJour().updatedAt,
        isNot(categorie.updatedAt),
      );
      expect(budget.avecHorodatageMiseAJour().createdAt, budget.createdAt);
      expect(
        budget.avecHorodatageMiseAJour().updatedAt,
        isNot(budget.updatedAt),
      );
    });

    test(
      'le désarchivage restaure une enveloppe active sans toucher sa création',
      () {
        final budget = Budget(
          id: 7,
          nom: 'Voyage',
          alloue: 2000,
          archive: true,
          createdAt: '2026-01-01T00:00:00.000',
          updatedAt: '2026-02-01T00:00:00.000',
        );

        final desarchive = budget.desarchiver();

        expect(desarchive.id, budget.id);
        expect(desarchive.nom, budget.nom);
        expect(desarchive.alloue, budget.alloue);
        expect(desarchive.archive, isFalse);
        expect(desarchive.createdAt, budget.createdAt);
        expect(desarchive.updatedAt, isNot(budget.updatedAt));
        expect(budget.archive, isTrue);
      },
    );

    test('la répartition regroupe les dépenses par famille', () {
      final lignes = repartitionParCategorie(
        transactions: [
          buildTransaction(montant: 8000, categorieId: 1, type: 'Depense'),
          buildTransaction(montant: 2000, categorieId: 2, type: 'Depense'),
          buildTransaction(montant: 50000, categorieId: 3, type: 'Revenu'),
        ],
        categories: [
          Categorie(id: 1, nom: 'Alimentation', famille: 'Essentiel'),
          Categorie(id: 2, nom: 'Transport', famille: 'Essentiel'),
          Categorie(id: 3, nom: 'Salaire', famille: 'Revenus'),
        ],
      );

      expect(lignes.single.famille, 'Essentiel');
      expect(lignes.single.montant, 10000);
    });

    test('la sélection de modification est un état explicite', () {
      const SelectionModificationTransaction initiale =
          SelectionModificationInitiale();
      final Categorie categorie = Categorie(
        id: 2,
        nom: 'Salaire',
        type: 'Revenu',
      );
      final Budget budget = Budget(id: 1, nom: 'Général', alloue: 1000);

      expect(initiale.categorie, isNull);
      expect(initiale.budget, isNull);

      final SelectionModificationTransaction choisie = initiale.avecCategorie(
        categorie,
      );
      expect(choisie, isA<SelectionModificationChoisie>());
      expect(choisie.categorie, same(categorie));
      expect(choisie.budget, isNull);

      final SelectionModificationTransaction avecBudget = choisie.avecBudget(
        budget,
      );
      expect(avecBudget.categorie, same(categorie));
      expect(avecBudget.budget, same(budget));
    });

    test('l’onglet d’analyse est un état explicite', () {
      expect(OngletAnalyse.values.map((onglet) => onglet.libelle).toList(), [
        'Enveloppes',
        'Répartition',
        'Transactions',
        'Personnalisation',
      ]);
      expect(OngletAnalyse.depuisIndex(0), OngletAnalyse.enveloppes);
      expect(OngletAnalyse.depuisIndex(3), OngletAnalyse.personnalisation);
      expect(OngletAnalyse.depuisIndex(-1), OngletAnalyse.enveloppes);
      expect(OngletAnalyse.depuisIndex(42), OngletAnalyse.personnalisation);
    });

    test('« Autre » reste toujours disponible', () {
      expect(
        estIndispensable(
          categoriesParDefaut.firstWhere(
            (categorie) =>
                categorie.nom == 'Autre' && categorie.type == 'Depense',
          ),
        ),
        isTrue,
      );
      expect(
        estIndispensable(
          categoriesParDefaut.firstWhere(
            (categorie) => categorie.nom == 'Autre revenu',
          ),
        ),
        isTrue,
      );
      expect(
        estIndispensable(Categorie(nom: 'Cinéma', type: 'Depense')),
        isFalse,
      );
    });
  });
}
