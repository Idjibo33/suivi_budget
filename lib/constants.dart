import 'package:flutter/material.dart';

/// Palette volontairement réduite à trois teintes : noir, blanc et teal.
/// Les gris sont des neutres (shades de noir/blanc), pas des couleurs
/// supplémentaires. Aucune couleur de statut verte ou rouge n'est utilisée :
/// le signe du montant et l'icône portent l'information.
abstract final class AppCouleurs {
  static const Color teal = Color(0xFF00796B);
  static const Color tealClair = Color(0xFF2DD4BF);
  static const Color tealTresClair = Color(0xFFE6F4F1);
  static const Color tealFonce = Color(0xFF0E3B36);

  static const Color blanc = Color(0xFFFFFFFF);
  static const Color noir = Color(0xFF0A0A0A);
  static const Color surfaceClaire = Color(0xFFF5F5F5);
  static const Color surfaceSombre = Color(0xFF141414);
  static const Color bordureClaire = Color(0xFFE6E6E6);
  static const Color bordureSombre = Color(0xFF2B2B2B);
  static const Color grisClair = Color(0xFF767676);
  static const Color grisSombre = Color(0xFFA3A3A3);
}

/// Thème unique de l'application, dérivé d'un [ColorScheme] explicite.
abstract final class AppTheme {
  static ThemeData get clair => _construire(_schemeClair);
  static ThemeData get sombre => _construire(_schemeSombre);

  static final ColorScheme _schemeClair = ColorScheme.light(
    primary: AppCouleurs.teal,
    onPrimary: AppCouleurs.blanc,
    primaryContainer: AppCouleurs.tealTresClair,
    onPrimaryContainer: AppCouleurs.noir,
    secondary: AppCouleurs.noir,
    onSecondary: AppCouleurs.blanc,
    secondaryContainer: AppCouleurs.surfaceClaire,
    onSecondaryContainer: AppCouleurs.noir,
    tertiary: AppCouleurs.noir,
    onTertiary: AppCouleurs.blanc,
    tertiaryContainer: AppCouleurs.surfaceClaire,
    onTertiaryContainer: AppCouleurs.noir,
    error: AppCouleurs.noir,
    onError: AppCouleurs.blanc,
    errorContainer: AppCouleurs.surfaceClaire,
    onErrorContainer: AppCouleurs.noir,
    surface: AppCouleurs.blanc,
    onSurface: AppCouleurs.noir,
    surfaceContainerHighest: AppCouleurs.surfaceClaire,
    onSurfaceVariant: AppCouleurs.grisClair,
    outline: AppCouleurs.bordureClaire,
    outlineVariant: AppCouleurs.bordureClaire,
    shadow: AppCouleurs.noir,
    scrim: AppCouleurs.noir,
    inverseSurface: AppCouleurs.noir,
    onInverseSurface: AppCouleurs.blanc,
    inversePrimary: AppCouleurs.tealClair,
    surfaceTint: AppCouleurs.teal,
  );

  static final ColorScheme _schemeSombre = ColorScheme.dark(
    primary: AppCouleurs.tealClair,
    onPrimary: AppCouleurs.noir,
    primaryContainer: AppCouleurs.tealFonce,
    onPrimaryContainer: AppCouleurs.blanc,
    secondary: AppCouleurs.blanc,
    onSecondary: AppCouleurs.noir,
    secondaryContainer: AppCouleurs.surfaceSombre,
    onSecondaryContainer: AppCouleurs.blanc,
    tertiary: AppCouleurs.blanc,
    onTertiary: AppCouleurs.noir,
    tertiaryContainer: AppCouleurs.surfaceSombre,
    onTertiaryContainer: AppCouleurs.blanc,
    error: AppCouleurs.blanc,
    onError: AppCouleurs.noir,
    errorContainer: AppCouleurs.surfaceSombre,
    onErrorContainer: AppCouleurs.blanc,
    surface: AppCouleurs.noir,
    onSurface: AppCouleurs.blanc,
    surfaceContainerHighest: AppCouleurs.surfaceSombre,
    onSurfaceVariant: AppCouleurs.grisSombre,
    outline: AppCouleurs.grisClair,
    outlineVariant: AppCouleurs.bordureSombre,
    shadow: AppCouleurs.noir,
    scrim: AppCouleurs.noir,
    inverseSurface: AppCouleurs.blanc,
    onInverseSurface: AppCouleurs.noir,
    inversePrimary: AppCouleurs.teal,
    surfaceTint: AppCouleurs.tealClair,
  );

  static ThemeData _construire(ColorScheme scheme) {
    final OutlineInputBorder bordure = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    );
    final OutlineInputBorder bordureActive = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: scheme.primary),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: TextTheme(
        displaySmall: Styles.texteMontant.copyWith(color: scheme.onSurface),
        headlineSmall: Styles.texteEnTete.copyWith(color: scheme.onSurface),
        titleMedium: Styles.texteTitre.copyWith(color: scheme.onSurface),
        bodyMedium: Styles.texteCorps.copyWith(color: scheme.onSurface),
        bodySmall: Styles.texteCorps.copyWith(
          fontSize: 12,
          color: scheme.onSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: Styles.texteEnTete.copyWith(
          fontSize: 17,
          color: scheme.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: bordure,
        enabledBorder: bordure,
        focusedBorder: bordureActive,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          minimumSize: const Size(64, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: Styles.texteTitre,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.primary,
          textStyle: Styles.texteTitre,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: scheme.onSurface),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        shape: const CircleBorder(),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurfaceVariant,
        indicatorColor: scheme.primary,
        labelStyle: Styles.texteTitre,
        unselectedLabelStyle: Styles.texteCorps,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: Styles.texteCorps.copyWith(
          color: scheme.onInverseSurface,
        ),
      ),
    );
  }
}

/// Styles typographiques partagés. Les couleurs ne sont pas figées ici :
/// elles viennent du [Theme] courant pour fonctionner en clair comme en sombre.
abstract final class Styles {
  // Police système : aucun téléchargement au runtime, rendu identique
  // dans les tests, le web et les applications natives.
  static const TextStyle texteEnTete = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
  );

  static const TextStyle texteTitre = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
  );

  static const TextStyle texteCorps = TextStyle(fontSize: 14);

  static const TextStyle texteMontant = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  static const TextStyle texteMontantCompact = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Revenu : seul accent coloré. Dépense : couleur de texte neutre.
  static Color couleurRevenu(BuildContext context) =>
      Theme.of(context).colorScheme.primary;

  static Color couleurDepense(BuildContext context) =>
      Theme.of(context).colorScheme.onSurface;

  static Color surfaceSecondaire(BuildContext context) =>
      Theme.of(context).colorScheme.surfaceContainerHighest;

  static Color bordure(BuildContext context) =>
      Theme.of(context).colorScheme.outlineVariant;

  static Color texteSecondaire(BuildContext context) =>
      Theme.of(context).colorScheme.onSurfaceVariant;
}
