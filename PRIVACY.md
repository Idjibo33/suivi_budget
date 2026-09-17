# Politique de Confidentialité — Suivi Budget

**Dernière mise à jour : 17 septembre 2026**  
**Application : Suivi Budget** (`com.suivibudget.app`) — version 1.0.0  
**Éditeur : Suivi Budget (Ismaël)**  
**Contact : ismael@[votre-domaine].com — remplacez par votre email support avant publication Play Store**

> **Résumé en une phrase :** Suivi Budget fonctionne **100% hors-ligne**. Aucune donnée n'est collectée, transmise ou stockée sur un serveur. Tout reste sur votre appareil.

---

## 1. Principe — Offline-first

Suivi Budget est une application de gestion budgétaire locale (`lib/Services/database/transaction_database.dart:9`, `floor` + `sqflite`).  
- Pas de création de compte, pas de serveur, pas de SDK analytics/publicitaire.  
- Pas de permission `INTERNET` déclarée (`android/app/src/main/AndroidManifest.xml`).  
- Aucun transfert réseau n'est effectué dans la branche `local-storage`.

## 2. Données que vous saisissez

Vous pouvez créer des transactions locales :

| Donnée | Exemple | Obligatoire |
|---|---|---|
| Montant | `15000` | oui |
| Catégorie | `Alimentation` | oui |
| Description | `Courses marché` | non |
| Type | `Revenu` / `Dépense` | oui |
| Date | `2026-09-17` | oui |

Ces données sont stockées **uniquement** dans la base SQLite locale `transaction_database` sur votre appareil (`transactions_table`, `lib/models/transaction.dart:4`).  
Elles ne quittent jamais l'appareil sauf si **vous** les exportez (fonctionnalité future d'export PDF — manipulation locale).

**Aucune donnée personnelle** (nom, email, prénom — `lib/models/utilisateur.dart`) n'est collectée dans la version 1.0.0. L'écran `Profil` (`lib/views/Profil/profil_screen.dart`) est statique.

## 3. Permissions demandées

| Permission | Pourquoi | Optionnel ? |
|---|---|---|
| `USE_BIOMETRIC` (`AndroidManifest.xml:2`) | Déverrouiller l'app via empreinte/visage/code appareil (`lib/Services/Local Auth/local_auth.dart:7`, `lib/views/Accueil/accueil_screen.dart:28`). Implémentation `local_auth` avec fallback gracieux : si biométrie indisponible, l'app s'ouvre sans bloquer | Oui — refus = accès direct (pas de `exit(0)`) |

Aucune autre permission (localisation, contacts, stockage, caméra, micro).

## 4. Données NON collectées

- Aucun identifiant (Advertising ID, Android ID, email, téléphone)
- Aucune donnée de localisation
- Aucune donnée financière bancaire (l'app ne se connecte à aucune banque)
- Aucun analytics, crashlytics, Firebase, Supabase, Facebook SDK dans cette branche offline (`pubspec.yaml` ne contient aucun `firebase_*`)
- Aucune publicité

Le fichier `android/app/google-services.json` présent historiquement sur `main` a été retiré de cette branche (`android/app/google-services.json.bak.offline`).

## 5. Stockage et durée de conservation

- **Lieu :** mémoire interne de l'appareil uniquement, via `Floor`/`sqflite` (`lib/Services/database/transaction_database.g.dart:100`).
- **Durée :** jusqu'à suppression par vous (bouton Supprimer `lib/views/widgets/transaction_details_view.dart:113`) ou désinstallation de l'app (supprime la base).
- **Sauvegarde système :** `android:allowBackup=true` et `dataExtractionRules.xml` autorisent la sauvegarde chiffrée Google (si vous l'activez dans Android). Vous pouvez la désactiver dans Réglages Android > Sauvegarde.

## 6. Partage et tiers

**Aucun partage.** Aucun fournisseur tiers n'a accès à vos données. Pas de transfert hors UE. Pas de vente.

## 7. Sécurité

- Chiffrement au repos : assuré par le chiffrement d'Android si vous avez un code/empreinte d'écran.
- Auth locale : `local_auth` `isDeviceSupported()` + `canCheckBiometrics` (`local_auth.dart:7`) + `SystemNavigator.pop()` en cas d'échec (pas de `exit(0)`).
- Base locale non chiffrée applicativement en 1.0.0 — une future mise à jour pourra ajouter `SQLCipher` si demandé. En attendant, la sécurité repose sur le verrouillage de l'appareil.

## 8. Droits (RGPD)

Puisque aucune donnée n'est transmise à l'éditeur, les droits d'accès/suppression s'exercent **localement** sur l'appareil :
- Consulter : liste `Transactions récents` (`lib/views/widgets/list_transactions_widgets.dart`)
- Supprimer : swipe → Supprimer ou détail → Supprimer
- Tout effacer : Paramètres Android > Applications > Suivi Budget > Effacer les données

Pour toute question RGPD : contactez l'email ci-dessus. Réponse sous 30 jours.

## 9. Enfants

L'app est tout public. Elle ne collecte sciemment aucune donnée d'enfants < 13 ans (et d'aucun utilisateur).

## 10. Modifications

Toute mise à jour de cette politique sera publiée dans ce fichier avec nouvelle date et, si modification substantielle, via note de mise à jour Play Store.

## 11. Contact & Responsable

**Responsable de traitement :** Ismaël — Éditeur Suivi Budget  
**Email :** `ismael@[votre-domaine].com`  
**Adresse postale :** [À compléter avant publication — requis Play Console > Fiche > Coordonnées]

---

### English Summary (for Play Console reviewers)

**Suivi Budget is fully offline.** All budget data (amount, category, description, type, date) is stored locally with `Floor/sqflite` and never sent to any server. No account, no internet permission, no analytics, no ads, no Firebase in `local-storage` branch. Only optional `USE_BIOMETRIC` for local authentication. Data stays on device until user deletes it or uninstalls the app.

---

### Hébergement requis Play Store

Play Console exige une **URL publique** pour cette politique. Hébergez ce fichier tel quel sur :
- GitHub Pages (ex: `https://[username].github.io/suivi_budget/PRIVACY.html`)
- ou votre site `https://suivibudget.app/privacy`

Puis coller l'URL dans **Play Console > Fiche Play Store > Politique de confidentialité**.

### Checklist avant envoi

- [ ] Remplacer `ismael@[votre-domaine].com` et adresse
- [ ] Vérifier `com.suivibudget.app` (`android/app/build.gradle.kts:18`)
- [ ] Conserver ce fichier en UTF-8, ne pas renommer après soumission URL
