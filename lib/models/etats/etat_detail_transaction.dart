/// État d'une fiche de transaction : consultation ou édition.
enum EtatDetailTransaction { consultation, edition }

extension EtatDetailTransactionTransitions on EtatDetailTransaction {
  EtatDetailTransaction basculer() =>
      this == EtatDetailTransaction.consultation
          ? EtatDetailTransaction.edition
          : EtatDetailTransaction.consultation;
}
