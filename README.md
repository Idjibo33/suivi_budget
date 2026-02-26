# suivi_budget

**Branch actuelle :** feature/firebase-backend

cette version de l'application privilégie la synchronisation et la sécurité.

- **Moteur :** Firebase Auth & Cloud Firestore.

## Fonctionnalités :

## Authentification
- Création de compte et connexion sécurisée via Firebase Auth.

## Gestion des Transactions
- **Opérations CRUD :** Enregistrement, modification et suppression des revenus et dépenses.
- **Calcul Automatique :** Mise à jour instantanée du solde global.

## Stockage des Données
- **Cloud Firestore :** Synchronisation des transactions et des profils utilisateurs sur le cloud.
- **Cache local :** Utilisation de SharedPreferences pour les préférences légères.

## Technologies utilisées 
- **Framework:** Flutter
- **Backend:** Firebase Auth, Cloud firestore   
- **Gstion d'etat:** Provider

## Aperçu 
<img src="assets/images/Accueil.png" width="250" alt="Capture d'écran"> | <img src="assets/images/Profil.png" width="250" alt="Capture d'écran"> | <img src="assets/images/Revenu.png" width="250" alt="Capture d'écran"> | <img src="assets/images/Depense.png" width="250" alt="Capture d'écran"> | <img src="assets/images/Details.png" width="250" alt="Capture d'écran"> | <img src="assets/images/Modifier.png" width="250" alt="Capture d'écran">


## Prochaines Étapes

- **Analyses graphiques :** Ajout de diagrammes pour visualiser les catégories de transactions.
- **Export PDF :** Génération de rapports.
- **Refonte UI :** Passage à un design plus moderne et support du Dark Mode.

***Projet réalisé dans le cadre d'un apprentissage Flutter & Firebase.***




