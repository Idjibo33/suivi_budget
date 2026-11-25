import 'package:flutter_test/flutter_test.dart';
import 'package:suivi_budget/models/etats/choix_periode_budget.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';

void main() {
  group('PeriodeBudget', () {
    test('le code mensuel donne une période mensuelle', () {
      final PeriodeBudget periode = PeriodeBudget.depuisCode('mensuel');

      expect(periode, isA<PeriodeMensuelle>());
      expect(periode.code, 'mensuel');
    });

    test('le code libre exige deux bornes valides', () {
      expect(() => PeriodeBudget.depuisCode('libre'), throwsArgumentError);
      expect(
        () => PeriodeBudget.depuisCode(
          'libre',
          debut: '2026-11-01',
          fin: '2026-10-31',
        ),
        throwsArgumentError,
      );

      final PeriodeBudget periode = PeriodeBudget.depuisCode(
        'libre',
        debut: '2026-10-01',
        fin: '2026-10-31',
      );
      expect(periode, isA<PeriodeLibre>());
      expect((periode as PeriodeLibre).debut, DateTime(2026, 10, 1));
      expect(periode.fin, DateTime(2026, 10, 31));
    });

    test('changerPeriode est une transition explicite', () {
      const PeriodeBudget mensuel = PeriodeMensuelle();
      final PeriodeBudget libre = mensuel.changerPeriode(
        choix: ChoixPeriodeBudget.libre,
        debut: '2026-10-01',
        fin: '2026-10-31',
      );

      expect(libre, isA<PeriodeLibre>());
      expect(libre.changerPeriode(choix: ChoixPeriodeBudget.mensuel), isA<PeriodeMensuelle>());
    });
  });
}
