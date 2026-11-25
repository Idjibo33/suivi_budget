import 'dart:async';

import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/models/transaction_entity.dart';
import 'package:suivi_budget/services/database/transaction_dao.dart';
import 'package:suivi_budget/services/local_auth.dart';

class FakeTransactionDao implements TransactionDao {
  final StreamController<List<Transaction>> _controller =
      StreamController<List<Transaction>>.broadcast();
  final StreamController<List<Categorie>> _categoriesController =
      StreamController<List<Categorie>>.broadcast();
  final StreamController<List<Budget>> _budgetsController =
      StreamController<List<Budget>>.broadcast();
  final List<Transaction> added = [];
  final List<Transaction> updated = [];
  final List<int> deleted = [];
  final List<Categorie> addedCategories = [];
  final List<Categorie> updatedCategories = [];
  final List<Budget> addedBudgets = [];
  final List<Budget> updatedBudgets = [];
  final Map<String, String> parametres = {};
  final Map<int, int> usagesCategories = {};

  Future<void> emit(List<Transaction> transactions) async {
    _controller.add(transactions);
    await Future<void>.value();
  }

  Future<void> emitCategories(List<Categorie> categories) async {
    _categoriesController.add(categories);
    await Future<void>.value();
  }

  Future<void> emitBudgets(List<Budget> budgets) async {
    _budgetsController.add(budgets);
    await Future<void>.value();
  }

  Future<void> emitError(Object error) async {
    _controller.addError(error);
    await Future<void>.value();
  }

  Future<void> close() async {
    await _controller.close();
    await _categoriesController.close();
    await _budgetsController.close();
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    added.add(transaction);
  }

  @override
  Future<void> editTransaction(Transaction transaction) async {
    updated.add(transaction);
  }

  @override
  Future<void> deleteTransaction(int id) async {
    deleted.add(id);
  }

  @override
  Stream<List<Transaction>> getTransactions() => _controller.stream;

  @override
  Future<void> addTransactionEntity(TransactionEntity transaction) async {}

  @override
  Future<void> editTransactionEntity(TransactionEntity transaction) async {}

  @override
  Future<void> addCategorie(Categorie categorie) async {
    addedCategories.add(categorie);
  }

  @override
  Future<void> editCategorieBrute(Categorie categorie) async {
    updatedCategories.add(categorie);
  }

  @override
  Future<void> editCategorie(Categorie categorie) async {
    updatedCategories.add(categorie);
  }

  @override
  Stream<List<Categorie>> getCategories() => _categoriesController.stream;

  @override
  Stream<List<Categorie>> getToutesCategories() => _categoriesController.stream;

  @override
  Future<int?> nombreTransactionsCategorie(int id) async =>
      usagesCategories[id] ?? 0;

  @override
  Future<void> addBudget(Budget budget) async {
    addedBudgets.add(budget);
  }

  @override
  Future<void> editBudgetBrute(Budget budget) async {
    updatedBudgets.add(budget);
  }

  @override
  Future<void> editBudget(Budget budget) async {
    updatedBudgets.add(budget);
  }

  @override
  // Reproduit le filtre SQL du DAO réel : les enveloppes archivées ne sont pas
  // exposées par ce flux, mais par `getToutBudgets`.
  Stream<List<Budget>> getBudgets() =>
      _budgetsController.stream.map((budgets) => budgets
          .where((budget) => !budget.archive)
          .toList(growable: false));

  @override
  Stream<List<Budget>> getToutBudgets() => _budgetsController.stream;

  @override
  Future<int?> nombreTransactionsBudget(int id) async => 0;

  @override
  Future<String?> lireParametre(String cle) async => parametres[cle];

  @override
  Future<void> ecrireParametre(String cle, String valeur) async {
    parametres[cle] = valeur;
  }
}

class FakeLocalAuth extends LocalAuth {
  FakeLocalAuth({this.result = true, this.estDisponible = false});

  bool result;
  bool estDisponible;
  int authenticationCalls = 0;
  int disponibiliteCalls = 0;

  @override
  Future<bool> estUtilisable() async {
    disponibiliteCalls++;
    return estDisponible;
  }

  @override
  Future<bool> authenticated({
    required String description,
    bool verifierDisponibilite = true,
  }) async {
    authenticationCalls++;
    return result;
  }
}

/// Catégories et enveloppe minimales pour les tests de formulaire.
Future<void> emitDonneesV2ParDefaut(FakeTransactionDao dao) async {
  await dao.emitCategories([
    Categorie(id: 1, nom: 'Courses', type: 'Depense', famille: 'Essentiel'),
    Categorie(id: 2, nom: 'Salaire', type: 'Revenu', famille: 'Revenus'),
  ]);
  await dao.emitBudgets([
    Budget(id: 1, nom: 'Général', alloue: 100000),
  ]);
}

Transaction buildTransaction({
  int? id,
  int montant = 1000,
  String category = 'Salaire',
  String description = 'Description',
  String type = 'Revenu',
  String date = '2026-10-19 08:00:00.000',
  int categorieId = 1,
  int? budgetId = 1,
}) {
  return Transaction(
    id: id,
    montant: montant,
    category: category,
    description: description,
    type: type,
    date: date,
    categorieId: categorieId,
    budgetId: budgetId,
  );
}
