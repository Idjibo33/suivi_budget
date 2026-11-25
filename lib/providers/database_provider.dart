import 'package:suivi_budget/models/modele_budget.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:suivi_budget/services/database/transaction_dao.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/categories_par_defaut.dart';
import 'package:suivi_budget/models/etats/etat_liste_transactions.dart';
import 'package:suivi_budget/models/etats/etat_operation.dart';
import 'package:suivi_budget/models/etats/modele_etat_vide.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';
import 'package:suivi_budget/models/etats/type_categorie.dart';
import 'package:suivi_budget/models/helpers/calcul_budget.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/success_snackbar.dart';
import 'package:suivi_budget/models/transaction.dart';

const String cleModeleEtatVide = 'modele_etat_vide';

class DatabaseProvider extends ChangeNotifier {
  final TransactionDao database;
  DatabaseProvider({required this.database});

  EtatListeTransactions _etatListe = const EtatListeChargement();
  EtatOperation _etatOperation = const EtatOperationInerte();
  List<Categorie> _categories = const <Categorie>[];
  List<Budget> _tousLesBudgets = const <Budget>[];
  ModeleEtatVide _modeleEtatVide = ModeleEtatVide.parDefaut;

  EtatListeTransactions get etatListe => _etatListe;
  EtatOperation get etatOperation => _etatOperation;

  // alias conservés pour les widgets et tests existants
  bool get listChargement => _etatListe.enChargement;
  String? get listErreur => _etatListe.messageErreur;
  List<Transaction> get transactionsListe => _etatListe.liste;
  bool get chargement => _etatOperation.enCours;

  List<Categorie> get categories => _categories;

  /// Les enveloppes actives, seules proposées lors d'une saisie.
  List<Budget> get budgets =>
      _tousLesBudgets.where((budget) => !budget.archive).toList();

  ModeleEtatVide get modeleEtatVide => _modeleEtatVide;

  Iterable<Categorie> categoriesDuType(TypeCategorie type) =>
      _categories.where((categorie) => categorie.typeCategorie == type);

  List<Categorie> get categoriesDepense =>
      categoriesDuType(TypeCategorie.depense).toList();

  List<Categorie> get categoriesRevenu =>
      categoriesDuType(TypeCategorie.revenu).toList();

  List<Budget> budgetsSelon(bool Function(Budget) filtre) =>
      _tousLesBudgets.where(filtre).toList();

  /// Toutes les écritures renvoient `true` uniquement après une écriture
  /// réussie : l'appelant peut ainsi refuser de fermer un dialogue ou d'effacer
  /// sa saisie. Le snackbar d'erreur reste géré ici, une seule fois.
  Future<bool> addTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) => _executer(
    context: context,
    etiquette: 'addTransaction',
    messageSucces: 'Transaction ajoutée avec succès',
    action: () => database.addTransaction(transaction),
  );

  Future<bool> updateTransaction(
    BuildContext context, {
    required Transaction transaction,
  }) => _executer(
    context: context,
    etiquette: 'updateTransaction',
    messageSucces: 'Transaction modifiée avec succès',
    action: () => database.editTransaction(transaction),
  );

  Future<bool> delteTransaction(BuildContext context, {required int id}) =>
      _executer(
        context: context,
        etiquette: 'delteTransaction',
        messageSucces: 'Transaction supprimé avec succès',
        action: () => database.deleteTransaction(id),
      );

  // ---------- V2 : catégories, enveloppes et modèle d'état vide ----------

  void listenDonneesV2() {
    database.getCategories().listen(
      (categories) => _changerV2(categories: categories),
      onError: (Object error) => log('Error in getCategories: $error'),
    );
    database.getToutBudgets().listen(
      (budgets) => _changerV2(budgets: budgets),
      onError: (Object error) => log('Error in getToutBudgets: $error'),
    );
  }

  Future<void> chargerModeleEtatVide() async {
    try {
      final String? json = await database.lireParametre(cleModeleEtatVide);
      if (json == null) {
        return;
      }
      _modeleEtatVide = ModeleEtatVide.depuisJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
      notifyListeners();
    } catch (error) {
      log('Error in chargerModeleEtatVide: $error');
    }
  }

  Future<bool> enregistrerModeleEtatVide(
    BuildContext context, {
    required ModeleEtatVide modele,
  }) async {
    final bool reussi = await _executer(
      context: context,
      etiquette: 'enregistrerModeleEtatVide',
      messageSucces: 'Modèle d’état vide enregistré',
      action: () => database.ecrireParametre(
        cleModeleEtatVide,
        jsonEncode(modele.toJson()),
      ),
    );
    if (!reussi) {
      return false;
    }
    _modeleEtatVide = modele;
    notifyListeners();
    return true;
  }

  Future<bool> ajouterCategorie(
    BuildContext context, {
    required Categorie categorie,
  }) => _executer(
    context: context,
    etiquette: 'ajouterCategorie',
    messageSucces: 'Catégorie créée',
    action: () => database.addCategorie(categorie),
  );

  Future<bool> renommerCategorie(
    BuildContext context, {
    required Categorie categorie,
    required String nouveauNom,
  }) async {
    // La protection de « Autre » est fondée sur son nom : la laisser renommer
    // la ferait disparaître sans migration de schéma.
    if (estIndispensable(categorie)) {
      const String message = 'La catégorie « Autre » ne peut pas être renommée';
      log('Refus de renommage : $message');
      _changerOperation(const EtatOperationEchec(message));
      if (context.mounted) showErrorSnackbar(context, message);
      return false;
    }
    final Categorie modifiee = categorie.renommer(nouveauNom);
    return _executer(
      context: context,
      etiquette: 'renommerCategorie',
      messageSucces: 'Catégorie renommée',
      action: () => database.editCategorie(modifiee),
    );
  }

  Future<int> nombreTransactionsCategorie(Categorie categorie) async {
    final int? id = categorie.id;
    if (id == null) {
      return 0;
    }
    return await database.nombreTransactionsCategorie(id) ?? 0;
  }

  Future<bool> archiverCategorie(
    BuildContext context, {
    required Categorie categorie,
    String messageSucces = 'Catégorie archivée',
  }) {
    final Categorie archivee = categorie.archiver();
    return _executer(
      context: context,
      etiquette: 'archiverCategorie',
      messageSucces: messageSucces,
      action: () => database.editCategorie(archivee),
    );
  }

  Future<bool> ajouterBudget(BuildContext context, {required Budget budget}) =>
      _executer(
        context: context,
        etiquette: 'ajouterBudget',
        messageSucces: 'Budget créé',
        action: () => database.addBudget(budget),
      );

  Future<bool> changerAutorisationDepassement(
    BuildContext context,
    Budget budget,
    bool autorise,
  ) => _executer(
    context: context,
    etiquette: 'changerAutorisationDepassement',
    messageSucces: 'Règle du budget mise à jour',
    action: () =>
        database.editBudget(budget.changerAutorisationDepassement(autorise)),
  );

  Future<bool> archiverBudget(BuildContext context, {required Budget budget}) {
    final Budget archive = budget.archiver();
    return _executer(
      context: context,
      etiquette: 'archiverBudget',
      messageSucces: 'Budget archivé',
      action: () => database.editBudget(archive),
    );
  }

  Future<bool> desarchiverBudget(
    BuildContext context, {
    required Budget budget,
  }) {
    final Budget desarchive = budget.desarchiver();
    return _executer(
      context: context,
      etiquette: 'desarchiverBudget',
      messageSucces: 'Budget désarchivé',
      action: () => database.editBudget(desarchive),
    );
  }

  List<ModeleBudget> _modelesBudget = const [];
  List<ModeleBudget> get modelesBudget => List.unmodifiable(_modelesBudget);

  Future<void> chargerModelesBudget() async {
    try {
      final valeur = await database.lireParametre('modeles_budget');
      if (valeur == null) return;
      _modelesBudget = (jsonDecode(valeur) as List)
          .map((item) => ModeleBudget.depuisJson(item as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } catch (error) {
      log('Impossible de charger les modèles : $error');
    }
  }

  Future<bool> enregistrerModelesBudget(
    BuildContext context,
    List<ModeleBudget> modeles,
  ) => _executer(
    context: context,
    etiquette: 'enregistrerModelesBudget',
    messageSucces: 'Modèles mis à jour',
    action: () async {
      await database.ecrireParametre('modeles_budget', jsonEncode(modeles));
      _modelesBudget = modeles;
    },
  );

  Map<String, int> _plafonds = {};

  Future<void> chargerPlafonds() async {
    try {
      final valeur = await database.lireParametre('plafonds_par_periode');
      if (valeur == null) return;
      _plafonds = Map<String, int>.from(jsonDecode(valeur) as Map);
      notifyListeners();
    } catch (error) {
      log('Impossible de charger les plafonds : $error');
    }
  }

  String _clePlafond(Budget budget, DateTime date) =>
      switch (budget.periodeValide) {
        PeriodeLibre() => '${budget.id}:libre',
        _ => '${budget.id}:${date.year}:${date.month}',
      };

  Future<bool> augmenterPlafond(
    BuildContext context,
    Budget budget,
    int plafond,
    DateTime date,
  ) => _executer(
    context: context,
    etiquette: 'augmenterPlafond',
    messageSucces: 'Plafond augmenté',
    action: () async {
      final nouveaux = {..._plafonds, _clePlafond(budget, date): plafond};
      await database.ecrireParametre(
        'plafonds_par_periode',
        jsonEncode(nouveaux),
      );
      _plafonds = nouveaux;
    },
  );

  /// Totaux calculés à partir des dates, sans compteur ni reset stocké.
  TotauxBudget totauxDuBudget(
    Budget budget, {
    DateTime? maintenant,
    int? transactionIgnoree,
  }) {
    if (budget.id == null) {
      return TotauxBudget(alloue: budget.alloue, apporte: 0, depense: 0);
    }
    final Iterable<LigneBudget> lignes = _etatListe.liste
        .where(
          (transaction) =>
              transaction.budgetId == budget.id &&
              transaction.estDepense &&
              (transactionIgnoree == null ||
                  transaction.id != transactionIgnoree),
        )
        .map(
          (transaction) => (
            montant: transaction.montant,
            type: TypeCategorie.depuisCode(transaction.type),
            date: transaction.date,
          ),
        );
    return calculerTotaux(
      alloue:
          _plafonds[_clePlafond(budget, maintenant ?? DateTime.now())] ??
          budget.alloue,
      periode: budget.periodeValide ?? const PeriodeMensuelle(),
      lignes: lignes,
      maintenant: maintenant,
    );
  }

  /// Exécute une écriture et renvoie `true` uniquement si elle a réussi.
  /// Le message reste affiché une seule fois, ici ; le booléen permet aux
  /// dialogues de garder leur saisie ouverte en cas d'échec.
  Future<bool> _executer({
    required BuildContext context,
    required String etiquette,
    required String messageSucces,
    required Future<void> Function() action,
  }) async {
    _changerOperation(const EtatOperationEnCours());
    try {
      await action();
      _changerOperation(EtatOperationSucces(messageSucces));
      if (context.mounted) showSuccessSnackbar(context, messageSucces);
      return true;
    } catch (error) {
      log('Error in $etiquette: $error');
      _changerOperation(EtatOperationEchec(error.toString()));
      if (context.mounted) showErrorSnackbar(context, error.toString());
      return false;
    }
  }

  void _changerOperation(EtatOperation etat) {
    _etatOperation = etat;
    notifyListeners();
  }

  void listenTransactions() {
    database.getTransactions().listen(
      (transactions) => _changerListe(etatListeApresFlux(transactions)),
      onError: (Object error) {
        log('Error in listenTransactions: $error');
        _changerListe(
          etatListeApresErreur(error, listePrecedente: _etatListe.liste),
        );
      },
    );
  }

  void _changerListe(EtatListeTransactions etat) {
    _etatListe = etat;
    notifyListeners();
  }

  void _changerV2({List<Categorie>? categories, List<Budget>? budgets}) {
    if (categories != null) {
      _categories = categories;
    }
    if (budgets != null) {
      _tousLesBudgets = budgets;
    }
    notifyListeners();
  }

  int totalRevenus() {
    return _transactionsFiltrees(
      'Revenu',
    ).fold(0, (total, element) => total + element.montant);
  }

  int totalDepenses() {
    return _transactionsFiltrees(
      'Depense',
    ).fold(0, (total, element) => total + element.montant);
  }

  /// Somme des plafonds actifs, distincte du solde global.
  int totalAlloue() =>
      budgets.fold(0, (total, budget) => total + budget.alloue);

  int soldeTotal() => totalRevenus() - totalDepenses();

  Iterable<Transaction> _transactionsFiltrees(String type) =>
      _etatListe.liste.where((transaction) => transaction.type == type);
}
