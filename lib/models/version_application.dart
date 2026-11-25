/// Version affichée dans le profil lorsque la plateforme ne peut pas fournir
/// `PackageInfo` (tests, environnement sans canal de plateforme).
///
/// Elle doit rester synchronisée avec le champ `version` du `pubspec.yaml`.
/// En production, `PackageInfo.fromPlatform().version` et `buildNumber`
/// prennent le pas sur cette valeur.
class VersionApplication {
  const VersionApplication._();

  static const String versionParDefaut = '1.0.0';
  static const String buildParDefaut = '1';

  /// Format attendu : `1.0.0+1` (version + numéro de build).
  static String formater(String version, String buildNumber) =>
      '$version+$buildNumber';

  static String get libelleParDefaut =>
      formater(versionParDefaut, buildParDefaut);
}
