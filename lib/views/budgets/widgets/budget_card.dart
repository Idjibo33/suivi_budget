import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/budget.dart';
import 'package:suivi_budget/models/etats/etat_jauge_budget.dart';
import 'package:suivi_budget/models/etats/periode_budget.dart';
import 'package:suivi_budget/models/helpers/calcul_budget.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/views/budgets/widgets/jauge_budget.dart';

/// Carte d'une enveloppe. Le choix de la période est explicite et affiché.
class BudgetCard extends StatelessWidget {
  final Budget budget;
  final TotauxBudget totaux;
  final bool selectionnee;
  final VoidCallback onTap;
  final VoidCallback? onArchive;
  final VoidCallback? onDesarchiver;

  const BudgetCard({
    super.key,
    required this.budget,
    required this.totaux,
    required this.selectionnee,
    required this.onTap,
    this.onArchive,
    this.onDesarchiver,
  });

  String libellePeriode(PeriodeBudget? periode) => switch (periode) {
    null => 'Période à préciser',
    PeriodeMensuelle() => 'Mensuel',
    PeriodeLibre(:final debut, :final fin) =>
      '${DateFormat('dd/MM', 'fr_FR').format(debut)} – '
          '${DateFormat('dd/MM', 'fr_FR').format(fin)}',
  };

  @override
  Widget build(BuildContext context) {
    final EtatJaugeBudget etat = EtatJaugeBudget.depuisTotaux(totaux);
    final ColorScheme couleurs = Theme.of(context).colorScheme;

    return SizedBox(
      width: 200,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: couleurs.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selectionnee ? couleurs.primary : Styles.bordure(context),
              width: selectionnee ? 1.6 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 18,
                    color: couleurs.primary,
                  ),
                  const Gap(6),
                  Expanded(
                    child: Text(
                      budget.nom,
                      style: Styles.texteTitre.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onArchive != null)
                    IconButton(
                      tooltip: 'Archiver',
                      icon: const Icon(Icons.archive_outlined, size: 18),
                      color: Styles.texteSecondaire(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 28,
                        height: 28,
                      ),
                      onPressed: onArchive,
                    ),
                  if (onDesarchiver != null)
                    IconButton(
                      tooltip: 'Désarchiver',
                      icon: const Icon(Icons.unarchive_outlined, size: 18),
                      color: Styles.texteSecondaire(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints.tightFor(
                        width: 28,
                        height: 28,
                      ),
                      onPressed: onDesarchiver,
                    ),
                ],
              ),
              const Gap(2),
              Text(
                libellePeriode(budget.periodeValide),
                style: Styles.texteCorps.copyWith(
                  fontSize: 11,
                  color: Styles.texteSecondaire(context),
                ),
              ),
              const Gap(12),
              Text(
                '${FormatMontant.afficherAvecDevise(totaux.depense)} dépensés '
                'sur ${FormatMontant.afficherAvecDevise(totaux.alloue)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Gap(8),
              JaugeBudget(totaux: totaux),
              const Gap(8),
              Text(
                FormatMontant.afficherAvecDevise(totaux.disponible.abs()),
                style: Styles.texteMontantCompact,
              ),
              Text(
                etat == EtatJaugeBudget.depasse
                    ? 'Au-delà du plafond'
                    : 'Reste à dépenser',
                style: Styles.texteCorps.copyWith(
                  fontSize: 10,
                  color: Styles.texteSecondaire(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
