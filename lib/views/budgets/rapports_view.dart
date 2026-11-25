import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/vue_budgets.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

class RapportsView extends StatefulWidget {
  const RapportsView({super.key});

  @override
  State<RapportsView> createState() => _RapportsViewState();
}

class _RapportsViewState extends State<RapportsView> {
  PeriodeRapport periode = PeriodeRapport.moisCourant;
  DateTimeRange? dates;
  int? budgetId;

  Future<void> choisirPeriode(PeriodeRapport? choix) async {
    if (choix == null) return;
    if (choix == PeriodeRapport.personnalisee) {
      final plage = await showDateRangePicker(
        context: context,
        firstDate: DateTime(1900),
        lastDate: DateTime(2200),
        initialDateRange: dates,
      );
      if (!mounted || plage == null) return;
      setState(() => dates = plage);
    }
    setState(() => periode = choix);
  }

  void ouvrirDepenses(String titre, List<Transaction> depenses) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(titre)),
          body: ListView.builder(
            itemCount: depenses.length,
            itemBuilder: (context, index) =>
                TransactionCard(transaction: depenses[index]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.watch<DatabaseProvider>();
    final maintenant = DateTime.now();
    final (debut, finExclusive) = switch (periode) {
      PeriodeRapport.moisCourant => (
        DateTime(maintenant.year, maintenant.month),
        DateTime(maintenant.year, maintenant.month + 1),
      ),
      PeriodeRapport.moisPrecedent => (
        DateTime(maintenant.year, maintenant.month - 1),
        DateTime(maintenant.year, maintenant.month),
      ),
      PeriodeRapport.personnalisee => (
        dates!.start,
        DateTime(dates!.end.year, dates!.end.month, dates!.end.day + 1),
      ),
    };
    final budgets = database.budgetsSelon((_) => true);
    final selection = budgets.any((budget) => budget.id == budgetId)
        ? budgetId
        : null;
    final depenses = database.transactionsListe.where((transaction) {
      final date = DateTime.tryParse(transaction.date)?.toLocal();
      return transaction.estDepense &&
          (selection == null || transaction.budgetId == selection) &&
          date != null &&
          !date.isBefore(debut) &&
          date.isBefore(finExclusive);
    }).toList();
    final categories = <String, List<Transaction>>{};
    for (final depense in depenses) {
      categories.putIfAbsent(depense.category, () => []).add(depense);
    }
    int montant(Iterable<Transaction> lignes) =>
        lignes.fold(0, (total, ligne) => total + ligne.montant);
    final total = montant(depenses);
    final repartition = categories.entries.toList()
      ..sort((a, b) => montant(b.value).compareTo(montant(a.value)));
    final format = DateFormat('dd/MM/yyyy', 'fr_FR');
    final dernierJour = DateTime(
      finExclusive.year,
      finExclusive.month,
      finExclusive.day - 1,
    );

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Où va mon argent ?', style: Styles.texteTitre),
        const SizedBox(height: 12),
        Wrap(
          spacing: 20,
          runSpacing: 8,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Période'),
                DropdownButton<PeriodeRapport>(
                  value: periode,
                  onChanged: choisirPeriode,
                  items: const [
                    DropdownMenuItem(
                      value: PeriodeRapport.moisCourant,
                      child: Text('Ce mois-ci'),
                    ),
                    DropdownMenuItem(
                      value: PeriodeRapport.moisPrecedent,
                      child: Text('Mois dernier'),
                    ),
                    DropdownMenuItem(
                      value: PeriodeRapport.personnalisee,
                      child: Text('Dates personnalisées'),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Budget'),
                DropdownButton<int>(
                  value: selection,
                  onChanged: (id) => setState(() => budgetId = id),
                  items: [
                    const DropdownMenuItem(child: Text('Tous les budgets')),
                    for (final budget in budgets)
                      DropdownMenuItem(
                        value: budget.id,
                        child: Text(
                          budget.archive
                              ? '${budget.nom} (archivé)'
                              : budget.nom,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text('${format.format(debut)} – ${format.format(dernierJour)}'),
        const Text('Total dépensé'),
        Text(
          FormatMontant.afficherAvecDevise(total),
          style: Styles.texteMontant,
        ),
        const SizedBox(height: 20),
        if (database.listChargement)
          const Center(child: CircularProgressIndicator())
        else if (database.listErreur != null)
          Text(database.listErreur!)
        else if (depenses.isEmpty)
          const Text('Aucune dépense pour cette période et ce filtre.')
        else ...[
          Text('Dépenses par catégorie', style: Styles.texteTitre),
          for (final entree in repartition)
            ListTile(
              title: Text(entree.key),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(FormatMontant.afficherAvecDevise(montant(entree.value))),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: total > 0
                        ? (montant(entree.value) / total)
                              .clamp(0.0, 1.0)
                              .toDouble()
                        : 0,
                  ),
                  const SizedBox(height: 6),
                  const Text('Voir les dépenses'),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => ouvrirDepenses(entree.key, entree.value),
            ),
          TextButton(
            onPressed: () => ouvrirDepenses('Dépenses de la période', depenses),
            child: const Text('Voir toutes les dépenses'),
          ),
        ],
      ],
    );
  }
}
