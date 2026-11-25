/// Choix explicite du type de période dans le formulaire d'enveloppe.
enum ChoixPeriodeBudget {
  mensuel('Mensuel'),
  libre('Période libre');

  const ChoixPeriodeBudget(this.libelle);

  final String libelle;
}
