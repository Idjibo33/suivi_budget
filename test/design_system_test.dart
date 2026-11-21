import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/views/widgets/transaction_card.dart';

import 'fixtures/fakes.dart';

/// Une couleur neutre a ses trois composantes égales : noir, blanc ou gris.
bool estNeutre(Color couleur) =>
    couleur.r == couleur.g && couleur.g == couleur.b;

double _luminance(Color couleur) {
  double canal(double valeur) => valeur <= 0.03928
      ? valeur / 12.92
      : math.pow((valeur + 0.055) / 1.055, 2.4).toDouble();

  return 0.2126 * canal(couleur.r) +
      0.7152 * canal(couleur.g) +
      0.0722 * canal(couleur.b);
}

double contraste(Color a, Color b) {
  final double claire = _luminance(a) > _luminance(b)
      ? _luminance(a)
      : _luminance(b);
  final double sombre = _luminance(a) < _luminance(b)
      ? _luminance(a)
      : _luminance(b);
  return (claire + 0.05) / (sombre + 0.05);
}

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  test('le thème clair se limite au noir, blanc et teal', () {
    final ColorScheme scheme = AppTheme.clair.colorScheme;

    expect(scheme.primary, AppCouleurs.teal);
    expect(scheme.surface, AppCouleurs.blanc);
    expect(scheme.onSurface, AppCouleurs.noir);
    for (final Color couleur in [
      scheme.secondary,
      scheme.tertiary,
      scheme.error,
      scheme.surfaceContainerHighest,
      scheme.outline,
    ]) {
      expect(estNeutre(couleur), isTrue, reason: '$couleur doit être neutre');
    }
  });

  test('le thème sombre garde le teal comme seul accent', () {
    final ColorScheme scheme = AppTheme.sombre.colorScheme;

    expect(scheme.primary, AppCouleurs.tealClair);
    expect(scheme.surface, AppCouleurs.noir);
    expect(scheme.onSurface, AppCouleurs.blanc);
    expect(estNeutre(scheme.secondary), isTrue);
    expect(estNeutre(scheme.error), isTrue);
  });

  test('les textes principaux respectent un contraste AA', () {
    for (final ThemeData theme in [AppTheme.clair, AppTheme.sombre]) {
      final ColorScheme scheme = theme.colorScheme;
      expect(contraste(scheme.onSurface, scheme.surface), greaterThanOrEqualTo(4.5));
      expect(contraste(scheme.onPrimary, scheme.primary), greaterThanOrEqualTo(4.5));
    }
  });

  test('les montants utilisent des chiffres tabulaires', () {
    expect(
      Styles.texteMontant.fontFeatures?.any((feature) => feature.feature == 'tnum'),
      isTrue,
    );
  });

  testWidgets('le signe distingue revenus et dépenses', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              TransactionCard(
                transaction: buildTransaction(type: 'Revenu', montant: 1000),
              ),
              TransactionCard(
                transaction: buildTransaction(type: 'Depense', montant: 500),
              ),
            ],
          ),
        ),
      ),
    );

    final String revenu = FormatMontant.afficherAvecSigne(
      1000,
      estRevenu: true,
      devise: false,
    );
    final String depense = FormatMontant.afficherAvecSigne(
      500,
      estRevenu: false,
      devise: false,
    );
    expect(find.text(revenu), findsOneWidget);
    expect(find.text(depense), findsOneWidget);

    final Text montant = tester.widget<Text>(find.text(revenu));
    expect(
      montant.style?.fontFeatures?.any((feature) => feature.feature == 'tnum'),
      isTrue,
    );
  });
}
