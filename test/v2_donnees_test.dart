import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart' hide Transaction;
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/categories_par_defaut.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/models/transaction_entity.dart';
import 'package:suivi_budget/services/database/transaction_database.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  late TransactionDatabase database;

  setUp(() async {
    database = await $FloorTransactionDatabase
        .inMemoryDatabaseBuilder()
        .build();
  });

  tearDown(() async {
    await database.close();
  });

  test('une transaction restitue le nom et le type de sa catégorie', () async {
    await database.transactionDao.addCategorie(
      Categorie(
        nom: 'Courses',
        type: 'Depense',
        famille: 'Essentiel',
        icone: 'i-cart',
        motif: 'vague',
      ),
    );
    await database.transactionDao.addBudget(
      Budget(nom: 'Maison', alloue: 100000),
    );
    await database.transactionDao.addTransactionEntity(
      TransactionEntity(
        montant: 1500,
        categorieId: 1,
        budgetId: 1,
        description: 'Courses',
        date: '2026-11-02T08:00:00',
      ),
    );

    final List<Transaction> transactions = await database.transactionDao
        .getTransactions()
        .first;

    expect(transactions, hasLength(1));
    expect(transactions.single.category, 'Courses');
    expect(transactions.single.type, 'Depense');
    expect(transactions.single.categorieId, 1);
    expect(transactions.single.budgetId, 1);
    expect(transactions.single.createdAt, isNotEmpty);
    expect(transactions.single.updatedAt, isNotEmpty);
  });

  test('les catégories et budgets actifs sont exposés par la base', () async {
    await database.transactionDao.addCategorie(
      Categorie(nom: 'Salaire', type: 'Revenu', famille: 'Revenus'),
    );
    await database.transactionDao.addCategorie(
      Categorie(
        nom: 'Ancienne',
        type: 'Depense',
        famille: 'Autre',
        archive: true,
      ),
    );
    await database.transactionDao.addBudget(
      Budget(nom: 'Voyage', alloue: 50000),
    );
    await database.transactionDao.addBudget(
      Budget(nom: 'Fermé', alloue: 1000, archive: true),
    );

    final categories = await database.transactionDao.getCategories().first;
    final budgets = await database.transactionDao.getBudgets().first;
    final tousLesBudgets = await database.transactionDao.getToutBudgets().first;

    expect(categories.map((c) => c.nom), ['Salaire']);
    expect(budgets.map((b) => b.nom), ['Voyage']);
    expect(tousLesBudgets.map((b) => b.nom), ['Fermé', 'Voyage']);
    expect(tousLesBudgets.first.archive, isTrue);
  });

  test('une catégorie utilisée ne peut pas être supprimée', () async {
    await database.transactionDao.addCategorie(
      Categorie(nom: 'Loyer', type: 'Depense', famille: 'Essentiel'),
    );
    await database.transactionDao.addBudget(Budget(nom: 'Maison', alloue: 1));
    await database.transactionDao.addTransactionEntity(
      TransactionEntity(
        montant: 100,
        categorieId: 1,
        budgetId: 1,
        description: 'Loyer',
        date: '2026-11-01T08:00:00',
      ),
    );

    expect(await database.transactionDao.nombreTransactionsCategorie(1), 1);
    expect(await database.transactionDao.nombreTransactionsBudget(1), 1);
  });

  test('éditer une catégorie ou un budget rafraîchit updated_at', () async {
    final categorie = Categorie(
      nom: 'Courses',
      type: 'Depense',
      createdAt: '2026-01-01T00:00:00.000',
      updatedAt: '2026-01-01T00:00:00.000',
    );
    await database.transactionDao.addCategorie(categorie);
    final budget = Budget(
      nom: 'Maison',
      alloue: 100000,
      createdAt: '2026-01-01T00:00:00.000',
      updatedAt: '2026-01-01T00:00:00.000',
    );
    await database.transactionDao.addBudget(budget);

    final categories = await database.transactionDao.getCategories().first;
    final budgets = await database.transactionDao.getBudgets().first;
    await database.transactionDao.editCategorie(categories.single);
    await database.transactionDao.editBudget(budgets.single);

    final categoriesModifiees = await database.transactionDao
        .getCategories()
        .first;
    final budgetsModifies = await database.transactionDao.getBudgets().first;
    expect(
      categoriesModifiees.single.updatedAt,
      isNot('2026-01-01T00:00:00.000'),
    );
    expect(categoriesModifiees.single.createdAt, '2026-01-01T00:00:00.000');
    expect(budgetsModifies.single.updatedAt, isNot('2026-01-01T00:00:00.000'));
    expect(budgetsModifies.single.createdAt, '2026-01-01T00:00:00.000');
  });

  test('les catégories par défaut couvrent revenus et dépenses', () {
    final depenses = categoriesParDefaut.where((c) => c.type == 'Depense');
    final revenus = categoriesParDefaut.where((c) => c.type == 'Revenu');
    expect(
      depenses.map((c) => c.nom),
      containsAll([
        'Alimentation',
        'Transport',
        'Logement',
        'Factures',
        'Santé',
        'Restaurants',
        'Vêtements',
        'Famille et soutien',
        'Autre',
      ]),
    );
    expect(
      revenus.map((c) => c.nom),
      containsAll([
        'Salaire',
        'Freelance',
        'Vente',
        'Bourse / Aide',
        'Remboursement',
        'Primes',
        'Cadeaux reçus',
        'Loyers reçus',
        'Autre revenu',
      ]),
    );
    expect(
      categoriesParDefaut.map((c) => (c.type, c.nom)).toSet(),
      hasLength(categoriesParDefaut.length),
    );
  });
}
