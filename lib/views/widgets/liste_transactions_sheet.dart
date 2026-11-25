import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_liste_transactions.dart';
import 'package:suivi_budget/models/etats/filtre_transactions.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/views/widgets/list_transactions_widgets.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

/// Feuille modale affichant l'intégralité des transactions avec un filtre.
///
/// Le filtre est local à la feuille : le widget reste un `StatefulWidget`
/// autonome, alimenté par le `DatabaseProvider` existant via `Consumer`.
class ListeTransactionsSheet extends StatefulWidget {
  const ListeTransactionsSheet({super.key});

  /// Point d'entrée unique, appelé par le bouton « voir tout » de l'accueil.
  static Future<void> afficher(BuildContext context) =>
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => const ListeTransactionsSheet(),
      );

  @override
  State<ListeTransactionsSheet> createState() => _ListeTransactionsSheetState();
}

class _ListeTransactionsSheetState extends State<ListeTransactionsSheet> {
  FiltreTransactions _filtre = FiltreTransactions.toutes;

  /// Le titre nomme toujours le filtre actif, y compris « Toutes ».
  String get _titre => switch (_filtre) {
    FiltreTransactions.toutes => 'Toutes les transactions',
    FiltreTransactions.revenus => 'Transactions · Revenus',
    FiltreTransactions.depenses => 'Transactions · Dépenses',
  };

  /// Message d'état vide accordé au filtre, pas seulement à la liste brute.
  String get _messageVide => switch (_filtre) {
    FiltreTransactions.toutes => 'Aucune transaction trouvée',
    FiltreTransactions.revenus => 'Aucun revenu trouvé',
    FiltreTransactions.depenses => 'Aucune dépense trouvée',
  };

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.85,
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(_titre, style: Styles.texteEnTete),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Fermer',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final FiltreTransactions filtre
                      in FiltreTransactions.values)
                    ChoiceChip(
                      label: Text(filtre.libelle),
                      selected: _filtre == filtre,
                      showCheckmark: false,
                      onSelected: (_) => setState(
                        () => _filtre = _filtre.selectionner(filtre),
                      ),
                    ),
                ],
              ),
            ),
            const Gap(12),
            Expanded(
              child: Consumer<DatabaseProvider>(
                builder: (context, database, child) => _corps(database),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _corps(DatabaseProvider database) {
    if (_filtre == FiltreTransactions.toutes) {
      // Aucune transformation : on réutilise le composant de l'accueil.
      return const ListTransactionsWidgets();
    }

    return switch (database.etatListe) {
      EtatListeChargement() => const Center(child: CircularProgressIndicator()),
      EtatListeErreur(message: final message) => _messageCentre(message),
      EtatListeVide() => _etatVide(),
      EtatListePret(transactions: final transactions) => _listeFiltree(
        transactions,
      ),
    };
  }

  Widget _listeFiltree(List<Transaction> transactions) {
    final List<Transaction> visibles = transactions
        .where(_filtre.accepte)
        .toList(growable: false);
    if (visibles.isEmpty) {
      return _etatVide();
    }
    return ListView.builder(
      itemCount: visibles.length,
      itemBuilder: (context, index) =>
          TransactionCard(transaction: visibles[index]),
    );
  }

  Widget _etatVide() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 40,
              color: Styles.texteSecondaire(context),
            ),
            const Gap(12),
            Text(
              _messageVide,
              style: Styles.texteCorps.copyWith(
                color: Styles.texteSecondaire(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _messageCentre(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Styles.texteCorps.copyWith(
            color: Styles.texteSecondaire(context),
          ),
        ),
      ),
    );
  }
}
