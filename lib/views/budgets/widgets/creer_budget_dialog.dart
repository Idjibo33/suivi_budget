import 'package:suivi_budget/models/modele_budget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/etats/choix_periode_budget.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/helpers/responsive.dart';
import 'package:suivi_budget/models/etats/validation_transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';

/// Création d'une enveloppe : l'utilisateur choisit explicitement sa période.
class CreerBudgetDialog extends StatefulWidget {
  const CreerBudgetDialog({
    super.key,
    this.nomInitial,
    this.modele,
    this.enregistrerModele,
  });

  final String? nomInitial;
  final ModeleBudget? modele;
  final Future<bool> Function(BuildContext, ModeleBudget)? enregistrerModele;

  @override
  State<CreerBudgetDialog> createState() => _CreerBudgetDialogState();
}

class _CreerBudgetDialogState extends State<CreerBudgetDialog> {
  late final TextEditingController _nom = TextEditingController(
    text: widget.modele?.nom ?? widget.nomInitial,
  );
  late bool _depassementAutorise = widget.modele?.depassementAutorise ?? false;
  late bool _datesAChoisir = widget.modele?.periodeLibre ?? false;
  late final TextEditingController _alloue = TextEditingController(
    text: widget.modele?.plafond?.toString(),
  );
  final PeriodeBudget _periodeInitiale = const PeriodeMensuelle();
  late PeriodeBudget _periode = _periodeInitiale;

  @override
  void dispose() {
    _nom.dispose();
    _alloue.dispose();
    super.dispose();
  }

  Future<void> choisirPeriodeLibre() async {
    final DateTime maintenant = DateTime.now();
    final DateTimeRange? range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(maintenant.year - 2),
      lastDate: DateTime(maintenant.year + 2),
      initialDateRange: DateTimeRange(
        start: maintenant,
        end: maintenant.add(const Duration(days: 30)),
      ),
    );
    if (!mounted || range == null) {
      return;
    }
    setState(() {
      _datesAChoisir = false;
      _periode = _periodeInitiale.changerPeriode(
        choix: ChoixPeriodeBudget.libre,
        debut: range.start.toIso8601String(),
        fin: range.end.toIso8601String(),
      );
    });
  }

  Future<void> enregistrer() async {
    final resultat = validerMontant(_alloue.text);
    if (resultat is! MontantValide || _nom.text.trim().isEmpty) {
      showErrorSnackbar(context, 'Nom et montant sont nécessaires');
      return;
    }
    final enregistrerModele = widget.enregistrerModele;
    if (enregistrerModele != null) {
      final reussi = await enregistrerModele(
        context,
        ModeleBudget(
          nom: _nom.text.trim(),
          plafond: resultat.montant,
          periodeLibre: _datesAChoisir || _periode is PeriodeLibre,
          depassementAutorise: _depassementAutorise,
        ),
      );
      if (reussi && mounted) Navigator.pop(context);
      return;
    }
    if (_datesAChoisir) {
      await choisirPeriodeLibre();
      if (!mounted || _datesAChoisir) return;
    }
    final PeriodeBudget periode = _periode;
    final bool reussi = await context.read<DatabaseProvider>().ajouterBudget(
      context,
      budget: Budget(
        nom: _nom.text.trim(),
        alloue: resultat.montant,
        depassementAutorise: _depassementAutorise,
        typePeriode: periode.code,
        dateDebut: periode.debut?.toIso8601String(),
        dateFin: periode.fin?.toIso8601String(),
      ),
    );
    if (reussi && mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String periodeLibelle = switch (_periode) {
      PeriodeMensuelle() => 'Mois courant',
      PeriodeLibre(:final debut, :final fin) =>
        '${DateFormat('dd/MM/yyyy', 'fr_FR').format(debut)} → '
            '${DateFormat('dd/MM/yyyy', 'fr_FR').format(fin)}',
    };

    return AlertDialog(
      title: Text(
        widget.enregistrerModele == null
            ? 'Nouveau budget'
            : 'Modèle personnel',
      ),
      content: SizedBox(
        width: Responsive.estGrandEcran(context) ? 420.0 : double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nom,
                decoration: const InputDecoration(labelText: 'Nom du budget'),
              ),
              const Gap(12),
              TextField(
                controller: _alloue,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Plafond de dépenses',
                  suffixText: 'F CFA',
                ),
              ),
              const Gap(8),
              const Text('Le plafond ne change pas votre solde global.'),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Autoriser le dépassement du plafond'),
                value: _depassementAutorise,
                onChanged: (autorise) =>
                    setState(() => _depassementAutorise = autorise),
              ),
              const Gap(16),
              SegmentedButton<ChoixPeriodeBudget>(
                segments: [
                  for (final choix in ChoixPeriodeBudget.values)
                    ButtonSegment(value: choix, label: Text(choix.libelle)),
                ],
                selected: {
                  if (_datesAChoisir)
                    ChoixPeriodeBudget.libre
                  else
                    switch (_periode) {
                      PeriodeMensuelle() => ChoixPeriodeBudget.mensuel,
                      PeriodeLibre() => ChoixPeriodeBudget.libre,
                    },
                },
                onSelectionChanged: (selection) async {
                  switch (selection.first) {
                    case ChoixPeriodeBudget.libre:
                      if (widget.enregistrerModele != null) {
                        setState(() => _datesAChoisir = true);
                      } else {
                        await choisirPeriodeLibre();
                      }
                    case ChoixPeriodeBudget.mensuel:
                      setState(() {
                        _datesAChoisir = false;
                        _periode = const PeriodeMensuelle();
                      });
                  }
                },
              ),
              const Gap(8),
              Text(
                _datesAChoisir
                    ? 'Dates à choisir à la création du budget'
                    : periodeLibelle,
              ),
              const Gap(8),
              Text(
                'Exemple de montant : ${FormatMontant.afficher(10000)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: context.watch<DatabaseProvider>().chargement
              ? null
              : enregistrer,
          child: Text(
            widget.enregistrerModele == null
                ? 'Créer'
                : 'Enregistrer le modèle',
          ),
        ),
      ],
    );
  }
}
