import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/models/etats/etat_authentification.dart';
import 'package:suivi_budget/models/etats/etat_detail_transaction.dart';
import 'package:suivi_budget/models/etats/etat_liste_transactions.dart';
import 'package:suivi_budget/models/etats/etat_operation.dart';
import 'package:suivi_budget/models/etats/etat_visibilite_solde.dart';
import 'package:suivi_budget/models/etats/validation_transaction.dart';
import 'package:suivi_budget/models/transaction.dart';

void main() {
  group('EtatAuthentification', () {
    test('le web entre directement dans l’état ignoré', () {
      final EtatAuthentification etat = demarrerAuthentification(
        contournerVerification: true,
      );
      expect(etat, isA<EtatAuthentificationIgnoree>());
      expect(etat.accueilAccessible, isTrue);
      expect(etat.authentifie, isFalse);
    });

    test('le natif vérifie puis applique le résultat', () {
      final EtatAuthentification debut = demarrerAuthentification(
        contournerVerification: false,
      );
      expect(debut, isA<EtatAuthentificationVerification>());
      expect(resultatAuthentification(true), isA<EtatAuthentificationAccordee>());
      expect(resultatAuthentification(false), isA<EtatAuthentificationRefusee>());
    });

    test('la biométrie indisponible ignore la vérification', () {
      expect(
        resultatDisponibiliteBiometrie(false),
        isA<EtatAuthentificationIgnoree>(),
      );
      expect(
        resultatDisponibiliteBiometrie(true),
        isA<EtatAuthentificationVerification>(),
      );
    });

    test('les alias booléens restent cohérents', () {
      expect(
        demarrerAuthentification(contournerVerification: false).enVerification,
        isTrue,
      );
      expect(resultatAuthentification(true).authentifie, isTrue);
      expect(resultatAuthentification(false).authentifie, isFalse);
      expect(resultatAuthentification(false).accueilAccessible, isFalse);
      expect(resultatDisponibiliteBiometrie(false).accueilAccessible, isTrue);
    });
  });

  group('EtatListeTransactions', () {
    test('une liste vide mène à l’état vide', () {
      expect(etatListeApresFlux(const []), isA<EtatListeVide>());
    });

    test('une liste non vide mène à l’état prêt', () {
      final EtatListeTransactions etat = etatListeApresFlux([
        Transaction(
          montant: 100,
          category: 'Salaire',
          description: 'Test',
          type: 'Revenu',
          date: '2026-10-19 08:00:00.000',
        ),
      ]);
      expect(etat, isA<EtatListePret>());
      expect((etat as EtatListePret).transactions, hasLength(1));
      expect(etat.enChargement, isFalse);
    });

    test('une erreur garde le message et la dernière liste', () {
      final EtatListeErreur etat = etatListeApresErreur(
        Exception('boom'),
        listePrecedente: [
          Transaction(
            montant: 100,
            category: 'Salaire',
            description: 'Test',
            type: 'Revenu',
            date: '2026-10-19 08:00:00.000',
          ),
        ],
      );
      expect(etat.message, 'Impossible de charger les transactions');
      expect(etat.messageErreur, 'Impossible de charger les transactions');
      expect(etat.liste, hasLength(1));
    });
  });

  group('EtatOperation', () {
    test('les états exposent chargement et message', () {
      expect(const EtatOperationEnCours().enCours, isTrue);
      expect(const EtatOperationInerte().enCours, isFalse);
      expect(const EtatOperationInerte().messageOperation, isNull);
      expect(const EtatOperationSucces('ok').message, 'ok');
      expect(const EtatOperationEchec('ko').message, 'ko');
    });
  });

  group('EtatDetailTransaction', () {
    test('la transition est un basculement explicite', () {
      expect(
        EtatDetailTransaction.consultation.basculer(),
        EtatDetailTransaction.edition,
      );
      expect(
        EtatDetailTransaction.edition.basculer(),
        EtatDetailTransaction.consultation,
      );
    });

    test('le provider garde son alias public', () {
      final ModifierTransactionViewProvider provider =
          ModifierTransactionViewProvider();
      expect(provider.etat, EtatDetailTransaction.consultation);
      provider.changer();
      expect(provider.etat, EtatDetailTransaction.edition);
      expect(provider.showview, isTrue);
      provider.afficherConsultation();
      expect(provider.showview, isFalse);
    });
  });

  group('EtatVisibiliteSolde', () {
    test('la visibilité bascule sans booléen inversé', () {
      expect(EtatVisibiliteSolde.visible.estMasque, isFalse);
      expect(EtatVisibiliteSolde.visible.basculer(), EtatVisibiliteSolde.masque);
      expect(EtatVisibiliteSolde.masque.estMasque, isTrue);
    });
  });

  group('validerMontant', () {
    test('rejette une saisie vide, nulle ou négative', () {
      for (final String saisie in ['', '  ', '0', '-3', 'abc']) {
        final ResultatValidationMontant resultat = validerMontant(saisie);
        expect(resultat, isA<MontantInvalide>());
        expect(
          (resultat as MontantInvalide).message,
          'Veuillez saisir un montant valide',
        );
      }
    });

    test('rejette un montant supérieur au solde', () {
      final ResultatValidationMontant resultat = validerMontant(
        '101',
        soldeDisponible: 100,
      );
      expect(resultat, isA<MontantInvalide>());
      expect((resultat as MontantInvalide).message, 'Solde insuffisant');
    });

    test('accepte un montant égal au solde', () {
      final ResultatValidationMontant resultat = validerMontant(
        '100',
        soldeDisponible: 100,
      );
      expect(resultat, isA<MontantValide>());
      expect((resultat as MontantValide).montant, 100);
    });

    test('accepte un montant sans contrôle de solde', () {
      final ResultatValidationMontant resultat = validerMontant('2500');
      expect((resultat as MontantValide).montant, 2500);
    });

    test('accepte un montant formaté issu d’un choix rapide', () {
      final ResultatValidationMontant resultat = validerMontant('10\u202F000');
      expect(resultat, isA<MontantValide>());
      expect((resultat as MontantValide).montant, 10000);
    });
  });
}
