import 'categorie.dart';

/// Catégories proposées à la première ouverture, pour les dépenses et revenus du quotidien.
/// L'utilisateur peut ensuite les renommer, en ajouter ou en archiver.
final List<Categorie> categoriesParDefaut = [
  Categorie(
    nom: 'Alimentation',
    type: 'Depense',
    famille: 'Essentiel',
    icone: 'i-cart',
    motif: 'pat-plein',
  ),
  Categorie(
    nom: 'Transport',
    type: 'Depense',
    famille: 'Essentiel',
    icone: 'i-bus',
    motif: 'pat-hachure',
  ),
  Categorie(
    nom: 'Logement',
    type: 'Depense',
    famille: 'Essentiel',
    icone: 'i-home',
    motif: 'pat-points',
  ),
  Categorie(
    nom: 'Santé',
    type: 'Depense',
    famille: 'Essentiel',
    icone: 'i-heart',
    motif: 'pat-ligne',
  ),
  Categorie(
    nom: 'Abonnements',
    type: 'Depense',
    famille: 'Style de vie',
    icone: 'i-repeat',
    motif: 'pat-contour',
  ),
  Categorie(
    nom: 'Loisirs',
    type: 'Depense',
    famille: 'Style de vie',
    icone: 'i-game',
    motif: 'pat-plein',
  ),
  Categorie(
    nom: 'Études',
    type: 'Depense',
    famille: 'Projets',
    icone: 'i-book',
    motif: 'pat-hachure',
  ),
  Categorie(
    nom: 'Autre',
    type: 'Depense',
    famille: 'Autre',
    icone: 'i-wallet',
    motif: 'pat-points',
  ),
  Categorie(
    nom: 'Salaire',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-wallet',
    motif: 'pat-plein',
  ),
  Categorie(
    nom: 'Freelance',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-laptop',
    motif: 'pat-ligne',
  ),
  Categorie(
    nom: 'Bourse / Aide',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-book',
    motif: 'pat-points',
  ),
  Categorie(
    nom: 'Remboursement',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-repeat',
    motif: 'pat-contour',
  ),
  Categorie(
    nom: 'Vente',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-bag',
    motif: 'pat-hachure',
  ),
  Categorie(
    nom: 'Autre revenu',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-wallet',
    motif: 'pat-points',
  ),
  ...nouvellesCategoriesParDefaut,
];

/// Ajouts au catalogue V2, aussi proposés aux installations existantes.
final List<Categorie> nouvellesCategoriesParDefaut = [
  Categorie(
    nom: 'Factures',
    type: 'Depense',
    famille: 'Essentiel',
    icone: 'i-home',
    motif: 'pat-ligne',
  ),
  Categorie(
    nom: 'Restaurants',
    type: 'Depense',
    famille: 'Style de vie',
    icone: 'i-cart',
    motif: 'pat-points',
  ),
  Categorie(
    nom: 'Vêtements',
    type: 'Depense',
    famille: 'Style de vie',
    icone: 'i-bag',
    motif: 'pat-hachure',
  ),
  Categorie(
    nom: 'Famille et soutien',
    type: 'Depense',
    famille: 'Essentiel',
    icone: 'i-heart',
    motif: 'pat-contour',
  ),
  Categorie(
    nom: 'Primes',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-wallet',
    motif: 'pat-hachure',
  ),
  Categorie(
    nom: 'Cadeaux reçus',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-bag',
    motif: 'pat-plein',
  ),
  Categorie(
    nom: 'Loyers reçus',
    type: 'Revenu',
    famille: 'Revenus',
    icone: 'i-home',
    motif: 'pat-ligne',
  ),
];

/// Les catégories « Autre » sont la fourchette de secours : elles restent
/// toujours disponibles, même après une personnalisation des libellés.
bool estIndispensable(Categorie categorie) => categoriesParDefaut.any(
  (defaut) =>
      defaut.type == categorie.type &&
      (defaut.nom == 'Autre' || defaut.nom == 'Autre revenu') &&
      defaut.nom == categorie.nom,
);
