import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

import 'fixtures/fakes.dart';

double _luminance(Color couleur) {
  double canal(double valeur) => valeur <= 0.03928
      ? valeur / 12.92
      : math.pow((valeur + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * canal(couleur.r) +
      0.7152 * canal(couleur.g) +
      0.0722 * canal(couleur.b);
}

double _contraste(Color a, Color b) {
  final double claire = math.max(_luminance(a), _luminance(b));
  final double sombre = math.min(_luminance(a), _luminance(b));
  return (claire + 0.05) / (sombre + 0.05);
}

ThemeData _theme(Brightness brightness) =>
    brightness == Brightness.light ? AppTheme.clair : AppTheme.sombre;

Future<Color> _couleurActionNeutre(WidgetTester tester, ThemeData theme) async {
  Color? couleur;
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) {
          couleur = Styles.couleurNeutreAction(context);
          return const SizedBox.shrink();
        },
      ),
    ),
  );
  return couleur!;
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  for (final Brightness brightness in Brightness.values) {
    testWidgets(
      'TransactionCard colore montant et icône de dépense en ${brightness.name}',
      (tester) async {
        final String montant = FormatMontant.afficherAvecSigne(
          500,
          estRevenu: false,
          devise: false,
        );

        expect(montant.startsWith('-'), isTrue);

        await tester.pumpWidget(
          MaterialApp(
            theme: _theme(brightness),
            home: Scaffold(
              body: TransactionCard(
                transaction: buildTransaction(type: 'Depense', montant: 500),
              ),
            ),
          ),
        );

        expect(find.text(montant), findsOneWidget);
        final Text texte = tester.widget<Text>(find.text(montant));
        expect(texte.style?.color, _theme(brightness).colorScheme.onSurface);
        final Icon icone = tester.widget<Icon>(
          find.byIcon(Icons.arrow_downward),
        );
        expect(icone.color, _theme(brightness).colorScheme.onSurface);
        expect(
          _contraste(icone.color!, _theme(brightness).colorScheme.surface),
          greaterThanOrEqualTo(4.5),
        );
      },
    );
  }

  for (final Brightness brightness in Brightness.values) {
    testWidgets(
      'le bouton Supprimer garde une couleur d’action neutre en ${brightness.name}',
      (tester) async {
        final ThemeData theme = _theme(brightness);
        final Color couleur = await _couleurActionNeutre(tester, theme);

        expect(couleur, theme.colorScheme.onSurface);
      },
    );
  }
}
