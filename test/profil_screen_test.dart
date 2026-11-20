import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/etats/etat_theme.dart';
import 'package:suivi_budget/providers/theme_provider.dart';
import 'package:suivi_budget/views/profil/profil_screen.dart';

void main() {
  testWidgets('la page profil propose les trois modes de thème', (tester) async {
    final ThemeProvider theme = ThemeProvider();

    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>.value(
        value: theme,
        child: const MaterialApp(home: Scaffold(body: ProfilScreen())),
      ),
    );

    expect(find.text('Profil'), findsOneWidget);
    expect(find.text('Apparence'), findsOneWidget);
    expect(find.text('Système'), findsOneWidget);
    expect(find.text('Clair'), findsOneWidget);
    expect(find.text('Sombre'), findsOneWidget);
    expect(find.text('Nom prenom'), findsNothing);
    expect(find.text('email'), findsNothing);

    await tester.tap(find.text('Sombre'));
    await tester.pump();

    expect(theme.mode, ModeTheme.sombre);
    expect(theme.themeMode, ThemeMode.dark);
  });
}
