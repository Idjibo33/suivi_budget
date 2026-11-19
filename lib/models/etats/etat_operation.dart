/// États d'une écriture CRUD : inerte, en cours, succès, échec.
/// L'état terminal reste mémorisé jusqu'à l'opération suivante, comme le
/// message d'origine.
sealed class EtatOperation {
  const EtatOperation();

  bool get enCours => this is EtatOperationEnCours;

  String? get messageOperation => switch (this) {
        EtatOperationSucces(message: final message) => message,
        EtatOperationEchec(message: final message) => message,
        _ => null,
      };
}

final class EtatOperationInerte extends EtatOperation {
  const EtatOperationInerte();
}

final class EtatOperationEnCours extends EtatOperation {
  const EtatOperationEnCours();
}

final class EtatOperationSucces extends EtatOperation {
  const EtatOperationSucces(this.message);

  final String message;
}

final class EtatOperationEchec extends EtatOperation {
  const EtatOperationEchec(this.message);

  final String message;
}
