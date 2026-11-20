# suivi_budget — notes pour agents

## Branche et périmètre

- `main` = production, `develop` = développement : une seule version de l'app (100 % locale, Floor/SQLite), présente sur les deux branches. Créer les branches de travail depuis `develop` ; les PR destinées à la prod visent `main`.
- Les anciennes branches backend (`backend-firebase`, `backend-supabase`, `feature/navigators`) et les branches de travail obsolètes ont été supprimées localement et sur `origin`. Ne pas les recréer : le projet n'a plus de version cloud.
- Ne pas pusher, merger ou déployer sans accord explicite.
- **Déploiement :** projet Vercel `suivi-budget-local` (scope `idjibo33s-projects`), Production Branch = `main`, vérifié avec `vercel project inspect suivi-budget-local`. L'Ignore Command ne déclenche un build que sur `main` : `if [ "$VERCEL_GIT_COMMIT_REF" == "main" ]; then exit 1; else exit 0; fi` (exit 0 = ignorer le build).
- Repo, UI et commentaires en français : répondre en français, commits Conventional Commits en français (cf. historique).

## Architecture

- `lib/providers/` : providers Provider (authentification, base de données, vue de détail).
- `lib/services/` : authentification locale et accès aux données (`lib/services/database/`).
- `lib/models/etats/` : machines à états explicites (voir règle plus bas).
- `lib/views/` : écrans (`accueil/`, `authentification/`, `profil/`, `transactions/`) et composants partagés (`widgets/`).
- `lib/constants.dart` : source unique de la palette et des thèmes (`AppTheme.clair`, `AppTheme.sombre`, `Styles`). Design volontairement limité au noir, blanc et teal ; ne pas introduire de vert/rouge (le signe `+`/`-` et l'icône portent le sens des montants).
- Tous les dossiers sont en `snake_case` minuscule, sans espace : importer avec `package:suivi_budget/...`.

## Vérification (ordre de la CI, `.github/workflows/flutter.yml`)

```sh
flutter pub get
flutter analyze
flutter test
flutter build web --release
```

- La CI installe `libsqlite3-dev` avant les tests : `test/transaction_dao_test.dart` utilise `sqflite_common_ffi` (`sqfliteFfiInit()`, `databaseFactoryFfi`, base en mémoire). Sur Linux sans cette librairie, ce test échoue.
- Test ciblé : `flutter test test/<fichier>.dart`. Fakes partagés dans `test/fixtures/fakes.dart` (`FakeTransactionDao`, `FakeLocalAuth`, `buildTransaction`).
- Avec Flutter 3.50, `flutter analyze` affiche ~49 infos `deprecated_member_use` sur `package:flutter/material.dart` et sort avec le code 1 : c'est préexistant, pas une régression. Distinguer ces infos des vraies erreurs ; traiter la migration au cas par cas si la tâche le demande.

## Câblage à connaître

- `lib/main.dart` appelle `configureDatabaseFactory()` avant `TransactionDatabase.initialize()`, fixe la locale `fr_FR`, puis monte trois providers : `ModifierTransactionViewProvider`, `AuthProvider`, `DatabaseProvider(..listenTransactions())`.
- `AccueilScreen` porte l'authentification locale elle-même (`LocalAuth.authenticated`) et la court-circuite sur le web (`kIsWeb`). `lib/auth_gate.dart` et les pages connexion/inscription existent mais ne sont pas sur le chemin de démarrage.
- Données Floor : table `transactions_table`, `@Database(version: 1)`, DAO exposant un `Stream` trié par `date DESC`. `montant` est un `int` ; `type` vaut exactement `"Revenu"` ou `"Depense"` (chaîne utilisée telle quelle pour les totaux).
- Web : `database_factory.dart` exporte conditionnellement `database_factory_web.dart` (`dart.library.js_interop`), qui installe `databaseFactoryFfiWeb`. `web/sqlite3.wasm` et `web/sqflite_sw.js` sont versionnés et nécessaires au stockage IndexedDB.
- Codegen : après une modification de `@Entity`, `@dao` ou `@Database`, lancer `dart run build_runner build --delete-conflicting-outputs` ; `lib/services/database/transaction_database.g.dart` est commité. Un changement de schéma exige de bump la version du `@Database` et une migration (aucune définie aujourd'hui).

## Règle de conception (à appliquer toujours)

- Modéliser toute machine à états implicite (booléens ou chaînes combinés, flag global, état dupliqué enfant/parent) dans `lib/models/etats/` avec un type explicite (`enum` ou `sealed class`), une transition nommée et un `switch` exhaustif côté UI. Les getters publics existants restent des alias du nouvel état pour préserver les appels.

## Dette confirmée

- `flutter_dotenv` est déclaré mais inutilisé (aucun appel Dart, `.env` ignoré) : aucune configuration par variables d'environnement n'est en place.
- `PROMPT_INITIAL.md` est un prompt de session daté (22/10/2026) conservé tel quel : ses références à `local-storage` et son plan d'audit ponctuel sont obsolètes ; seules ses règles de commit restent valables.
