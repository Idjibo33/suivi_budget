# MyBudget — responsive multiplateforme et releases prod/dev

## Intention

L'application doit rester 100 % locale, mais devenir utilisable sur téléphone, tablette, Web, Windows et Linux. Son nom affiché passe de `suivi_budget` à **MyBudget**. Un push sur `develop` doit produire une release de développement installable/downloadable, et un push sur `main` doit produire la release de production correspondante, sans publication automatique dans les stores. Vercel est déconnecté du dépôt : l'URL Web de référence devient celle de GitHub Pages. La release Android de production doit être un AAB signé, directement publishable sur la Play Store.

## Objectifs

1. Adapter l'interface aux largeurs téléphone, tablette et desktop sans refondre la direction artistique noir/blanc/teal.
2. Générer les runners Flutter manquants pour Linux et Windows, et rendre le stockage SQLite local fonctionnel dessus.
3. Configurer une identité cohérente : nom affiché, identifiant, version, description, couleurs PWA, métadonnées.
4. Séparer proprement prod (`main`) et dev (`develop`) : noms, identifiants Android, artifacts et URL Web distincts.
5. Faire produire par GitHub Actions des artifacts installables pour Android, iOS simulateur, Web, Linux et Windows.
6. Fournir une URL stable pour le Web de développement.

## Non-objectifs

- Publication automatique dans les stores : l'AAB prod est seulement préparé pour un téléversement manuel dans la Play Console.
- IPA signé avec un compte Apple Developer : l'utilisateur a choisi un build iOS de simulateur non signé.
- Support macOS : non demandé, même si `.metadata` le déclare historiquement.
- Ajout d'un backend, d'analytics, de comptes utilisateurs ou de synchronisation cloud.
- Refonte graphique, changement de palette ou traduction horsfrançais.
- Migration de schéma SQLite : le schéma reste en version 1.
- Merge ou push automatique vers `main`/`develop` sans accord humain explicite.

## Contraintes

- Dépôt français, commentaires et commits en français, Conventional Commits.
- `AGENTS.md` : ne pas pusher, merger ou déployer sans accord explicite ; PR de travail depuis `develop`, PR de prod vers `main`.
- La branche `feature/refonte-ui-themes` a été fusionnée dans `develop` (`origin/develop` = `c02ad53`). `main` local contient deux commits non poussés ; `origin/main` est encore en retard.
- Tests existants sensibles : largeur exacte de 600 px du contenu d'accueil sur grand écran, unique route poussée pour l'ajout, libellés uniques dans le profil, types de routes, format des cartes et des montants.
- Design system : palette limitée au noir, blanc et teal ; le signe `+`/`-` et l'icône portent le sens des montants.
- Avec Flutter 3.50, `flutter analyze` émet des infos `deprecated_member_use` préexistantes ; la CI utilise `--no-fatal-infos`.
- Le plugin Firebase et le `google-services.json` du projet `culturpass` sont présents alors que l'app est locale : ils seront retirés avec le plugin Gradle associé.

## Décisions

### Identité

| Élément | Prod (`main`) | Dev (`develop`) |
| :--- | :--- | :--- |
| Nom affiché | `MyBudget` | `MyBudget Dev` |
| Identifiant Android | `com.mybudget.app` | `com.mybudget.app.dev` |
| Identifiant iOS (build simulateur) | `com.mybudget.app` | `com.mybudget.app.dev` |
| Titre/manifeste Web | `MyBudget` | `MyBudget Dev` |
| Version | `1.0.0+<build CI>` | `1.0.0+<build CI>` |
| URL Web | `https://idjibo33.github.io/suivi_budget/` | `https://idjibo33.github.io/suivi_budget/dev/` |
| Artifacts GitHub | suffixe `prod` | suffixe `dev` |
| Android | AAB signé, prêt pour la Play Console | APK signé installable |

- Le numéro de build reste entier : `version: 1.0.0+1` dans `pubspec.yaml`, puis `--build-number ${{ github.run_number }}` en CI. Le suffixe `-dev` n'entre jamais dans `versionName` ni dans `CFBundleVersion` ; il est porté par `APP_FLAVOR`, les noms affichés et les identifiants.
- Éditeur : **MyBudget (Ismaël)** ; contact : `djiboismaelzeno@gmail.com` (le texte « remplacez par votre email support » est retiré de `PRIVACY.md`).
- Le nom du package Dart reste `suivi_budget` : c'est un choix interne aux imports, sans impact sur l'identité affichée. Le changer obligerait à réécrire tous les imports et n'apporte rien à l'utilisateur.
- Le nouveau nom apparaît aussi dans l'interface : en-tête de l'accueil et pied de la page Profil. Le code lit un helper central basé sur `APP_FLAVOR`, avec `MyBudget` par défaut et `MyBudget Dev` en dev ; les tests existants sont mis à jour en conséquence.
- `pubspec.yaml`, `web/index.html`, `web/manifest.json`, `AndroidManifest.xml`, `Info.plist`, `PRIVACY.md` et `README.md` utilisent la nouvelle identité.
- Les couleurs Web passent du bleu Flutter `#0175C2` au teal de l'app `#00796B`.
- La description générique « A new Flutter project. » est remplacée par une description française de l'app.
- Le libellé Face ID est traduit en français.

### Responsive

- Un shell adaptatif unique, piloté par `LayoutBuilder` et la largeur disponible :
  - `< 600` : comportement téléphone actuel, aucune navigation latérale ;
  - `600–999` : `NavigationRail` compact (icônes) ;
  - `>= 1000` : `NavigationRail` étendu (icônes + libellés).
- Les destinations sont modélisées dans `lib/models/etats/` par un `enum` explicite avec transition nommée et `switch` exhaustif dans le shell, conformément à `AGENTS.md`.
- Le bouton d'ajout continue d'utiliser le `Navigator.push` existant pour ne pas casser `navigation_test.dart`.
- Le contenu reste centré et borné (600 px sur l'accueil, largeur raisonnable pour les formulaires) : pas d'étirement sur grand écran.
- Le panneau de détail devient un dialogue centré et borné au-delà d'une largeur seuil ; la feuille modale actuelle reste sur petit écran.
- Le sélecteur de date utilise `showDatePicker` Material sur desktop/Web grand écran, et le picker Cupertino actuel sur mobile.
- Le `Drawer` du profil garde son comportement téléphone ; sur grand écran, sa largeur est bornée et le rail peut l'ouvrir via une clé de `Scaffold` optionnelle.
- Le `<meta name="viewport">` manquant est ajouté au Web.
- Les tests existants sont préservés : le chemin téléphone et le `ValueKey('home_content')` restent inchangés.

### Plateformes et stockage

- Les runners `linux/` et `windows/` sont générés avec `flutter create --platforms=linux,windows .`.
- `sqflite_common_ffi` et `sqlite3` passent de `dev_dependencies` à `dependencies` : ils sont nécessaires au runtime desktop.
- La factory de base de données native initialise sqflite FFI uniquement sur desktop (Linux/Windows), jamais sur Android/iOS où le plugin sqflite natif reste utilisé.
- Aucune biométrie n'est requise sur desktop : `LocalAuth.estUtilisable()` continue de court-circuiter l'authentification si le matériel est absent.

### Prod / dev et CI

- Deux flavors Android `prod` et `dev` avec `applicationIdSuffix = ".dev"` pour dev ; deux noms d'application via `strings.xml` par source set.
- Le flavor est piloté par la branche dans la CI (`main` → `prod`, `develop` → `dev`) et transmis aux builds via `--flavor` et `--dart-define=APP_FLAVOR=...`.
- Une nouvelle clé de signature Android est générée localement puis enregistrée avec le token GitHub de l'agent dans les secrets du dépôt :
  - `ANDROID_KEYSTORE_BASE64`
  - `ANDROID_KEYSTORE_PASSWORD`
  - `ANDROID_KEY_ALIAS`
  - `ANDROID_KEY_PASSWORD`
- Aucun mode dégradé n'est prévu : si un secret manque, le job Android échoue explicitement plutôt que de produire un APK non signé.
- Le fichier de keystore reste hors du dépôt ; `key.properties` et `*.jks` restent ignorés.
- iOS : job `macos-latest`, build `flutter build ios --no-codesign --simulator` avec ajustement de l'`Info.plist` du `.app` selon le flavor. Le `.app` résultant est zippé comme artifact. Aucun IPA installable sur appareil physique n'est promis.
- Web : build Flutter avec `--base-href=/suivi_budget/` pour prod et `--base-href=/suivi_budget/dev/` pour dev ; pour dev, un script patch le titre, le manifeste et les couleurs dans le dossier de build avant upload et déploiement GitHub Pages.
- Linux : job Ubuntu avec `clang`, `cmake`, `ninja-build`, `libgtk-3-dev`, `pkg-config`, `libsqlite3-dev`.
- Windows : job `windows-latest`, zip du dossier `build/windows/x64/runner/Release`.
- Chaque job Upload produit un artifact nommé `mybudget-<flavor>-<plateforme>-<sha court>`.
- Le workflow garde un job de vérification (`analyze --no-fatal-infos`, `test`, `build web`) sur PR et push, et ajoute un job de release uniquement sur push de `main`/`develop`.
- GitHub Pages est activé via l'API GitHub avec le token de l'agent (l'agent a les droits admin), source `Deploy from a branch`, branche `gh-pages`. Le déploiement utilise `peaceiris/actions-gh-pages@v4` avec `keep_files: true` : `main` publie à la racine, `develop` publie dans `/dev/`, avec `permissions: contents: write`. Les deux URL stables sont `https://idjibo33.github.io/suivi_budget/` et `https://idjibo33.github.io/suivi_budget/dev/`.
- Vercel est déconnecté avec le CLI (`npx vercel link --project suivi-budget-local --scope idjibo33s-projects --yes` puis `npx vercel git disconnect`) ; le projet Vercel lui-même n'est pas supprimé. `AGENTS.md` et `README.md` sont mis à jour pour ne plus présenter Vercel comme canal de déploiement.
- Android prod produit un AAB signé avec `flutter build appbundle --release --flavor prod`, un `versionCode` entier fourni par `--build-number=${{ github.run_number }}` et aucun fallback sur la clé debug. L'artifact AAB est celui à téléverser dans la Play Console.

### Branches et livraison

1. Créer `feature/mybudget-responsive-release` depuis `origin/develop`.
2. Implémenter, tester, ouvrir une PR vers `develop`.
3. Après validation et fusion dans `develop`, demander explicitement l'accord pour aligner `main` sur `develop` et pusher les deux branches. Aucun push ni merge n'est effectué avant cet accord.

## Laissé au builder

- Détail exact des seuils et des widgets du shell, du moment qu'ils respectent les décisions ci-dessus.
- Choix de la structure des fichiers de flavor Android/iOS et du script de patch Web.
- Ajustements mineurs de tests nécessaires pour couvrir les nouveaux comportements, sans affaiblir les assertions existantes.
- Pinning de la version Flutter dans la CI si nécessaire pour la reproductibilité.

## Risques

- L'iOS non signé n'est installable que dans un simulateur : à documenter clairement dans le README et les noms d'artifacts.
- Le premier build Windows en CI n'est pas reproductible localement depuis Linux : il sera validé par la CI elle-même.
- La rotation ou la perte des secrets Android impose de régénérer les artifacts ; la clé n'est pas versionnée.
- Le changement d'`applicationId` crée une nouvelle app Android distincte de l'ancienne `com.example.suivi_budget` : les utilisateurs de l'ancienne version ne recevront pas de mise à jour sur le même identifiant. C'est assumé : l'ancienne identité était un placeholder `com.example`.
- GitHub Pages est lié au nom du dépôt `suivi_budget` ; un changement de nom de dépôt changerait l'URL.
- L'AAB est prêt pour la Play Console, mais la publication reste manuelle : fiche store, texte de sortie, track et validation Google ne sont pas automatisés.
- La déconnexion Vercel supprime les previews Vercel existantes ; les URL `*.vercel.app` ne doivent plus être documentées comme canoniques.
