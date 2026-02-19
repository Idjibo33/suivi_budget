# suivi_budget — Édition Persistance Locale (SQLite/Floor)

Cette version de l'application privilégie la confidentialité et la rapidité en stockant 100% des données sur l'appareil de l'utilisateur.

## Points Forts de cette Version
Contrairement à la version Cloud (Firebase), cette branche utilise une architecture Local-First 
- **Confidentialité Totale :** Aucune donnée de transaction ne quitte le téléphone.
- **Performance Offline :** L'application fonctionne parfaitement sans connexion internet.
- **Architecture Type-Safe :** Utilisation de Floor, une bibliothèque d'abstraction SQLite garantissant une gestion des données robuste et sécurisée.

## Fonctionnalités
### Gestion des Transactions
- **CRUD Local :** Ajout, modification et suppression de revenus/dépenses avec persistance immédiate.
- **Filtrage Dynamique :** Système de tri sur l'écran d'accueil pour isoler les flux financiers.
- **Calcul de Solde :** Calcul en temps réel basé sur les entrées de la base SQLite.

## Expérience Utilisateur
- **Onboarding Personnalisé :** Accueil avec configuration du nom d'utilisateur, stocké de manière permanente.
- **Interface Réactive :** Utilisation du pattern Provider pour notifier l'UI dès qu'une modification survient dans la base Floor.

## Technologies utilisées 
- **Framework :** Flutter
- **Base de Données :** Floor, Sqflite
- **Gestion d'etat :** Provider

## Statut de l'application :

Ce projet est MVP et est évolutif au fil du temps

- Front-End (UI/UX) Complet Le design et la mise en page sont finalisés et réactifs pour un MVP.
- Logique d'enregistrement des revenus et dépenses  complet pour un MVP.
- Déploiement Non applicable, Projet personnel, non destiné à au public.


## Objectif de ce projet :

L'objectif est de créer une application mobile de gestion de finances personnelles permettant à l'utilisateur de suivre ses transactions quotidiennes tout en personnalisant son expérience. L'accent est mis sur la persistance locale (les données restent dans le téléphone) et la réactivité de l'interface.


## Aperçu du design
![Écran accueil](assets/images/Accueil.png)


## Évolutions prévues
- **Mode Sombre** 
- **Notifications :** Rappels quotidiens pour enregistrer les transactions de la journée. 
- **Statistiques** 
- **Export CSV** 
- **Catégories personnalisées** 

***Projet réalisé par un apprenant Flutter passionné par l'architecture logicielle et la gestion des données.***



