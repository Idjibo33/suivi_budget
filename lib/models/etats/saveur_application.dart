/// Saveur de l'application, pilotée par le `--dart-define=APP_FLAVOR=...`.
///
/// Le code inconnu retombe volontairement sur la production : une release
/// publiée ne doit jamais afficher « Dev » à cause d'une simple faute de frappe.
enum SaveurApplication {
  prod('prod', 'MyBudget', 'com.mybudget.app'),
  dev('dev', 'MyBudget Dev', 'com.mybudget.app.dev');

  const SaveurApplication(this.code, this.nomAffiche, this.identifiant);

  final String code;
  final String nomAffiche;
  final String identifiant;

  static SaveurApplication depuisCode(String code) => switch (code) {
        'dev' => dev,
        _ => prod,
      };
}

/// Saveur effective de l'application pour cette compilation.
final SaveurApplication saveurApplication = SaveurApplication.depuisCode(
  const String.fromEnvironment('APP_FLAVOR', defaultValue: 'prod'),
);
