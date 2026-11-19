import 'package:suivi_budget/models/transaction.dart';

/// États de la liste : chargement, erreur, vide, prête.
sealed class EtatListeTransactions {
  const EtatListeTransactions();

  bool get enChargement => this is EtatListeChargement;

  String? get messageErreur => switch (this) {
        EtatListeErreur(message: final message) => message,
        _ => null,
      };

  List<Transaction> get liste => switch (this) {
        EtatListePret(transactions: final transactions) => transactions,
        EtatListeErreur(listePrecedente: final liste) => liste,
        _ => const <Transaction>[],
      };
}

final class EtatListeChargement extends EtatListeTransactions {
  const EtatListeChargement();
}

final class EtatListeErreur extends EtatListeTransactions {
  const EtatListeErreur(
    this.message, {
    this.listePrecedente = const <Transaction>[],
  });

  final String message;

  /// Les totaux continuent de s'appuyer sur la dernière liste reçue.
  final List<Transaction> listePrecedente;
}

final class EtatListeVide extends EtatListeTransactions {
  const EtatListeVide();
}

final class EtatListePret extends EtatListeTransactions {
  const EtatListePret({required this.transactions});

  final List<Transaction> transactions;
}

const String messageErreurListe = 'Impossible de charger les transactions';

EtatListeTransactions etatListeApresFlux(List<Transaction> transactions) =>
    transactions.isEmpty
        ? const EtatListeVide()
        : EtatListePret(transactions: transactions);

EtatListeErreur etatListeApresErreur(
  Object error, {
  List<Transaction> listePrecedente = const <Transaction>[],
}) =>
    EtatListeErreur(messageErreurListe, listePrecedente: listePrecedente);
