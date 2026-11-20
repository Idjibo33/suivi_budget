import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers/database_provider.dart';
import 'package:suivi_budget/providers/modifier_transaction_view_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/etats/etat_detail_transaction.dart';
import 'package:suivi_budget/models/helpers/format_montant.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/custom_text_button_widget.dart';
import 'package:suivi_budget/views/widgets/modifier_transaction.dart';

class TransactionDetailsView extends StatelessWidget {
  final Transaction transaction;
  const TransactionDetailsView({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return _DetailsBody(transaction: transaction);
  }
}

class _DetailsBody extends StatelessWidget {
  final Transaction transaction;
  const _DetailsBody({required this.transaction});

  Widget _ligne(BuildContext context, String libelle, String valeur, Color couleur) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            libelle,
            style: Styles.texteCorps.copyWith(
              color: Styles.texteSecondaire(context),
            ),
          ),
          Flexible(
            child: Text(
              valeur,
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Styles.texteTitre.copyWith(color: couleur),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool enEdition =
        context.watch<ModifierTransactionViewProvider>().etat ==
        EtatDetailTransaction.edition;
    final bool estRevenu = transaction.type == "Revenu";
    final Color couleurMontant = estRevenu
        ? Styles.couleurRevenu(context)
        : Styles.couleurDepense(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Gap(8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DÉTAIL',
                  style: Styles.texteCorps.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                    color: Styles.texteSecondaire(context),
                  ),
                ),
              ),
              const Gap(12),
              Text(
                FormatMontant.afficherAvecSigne(
                  transaction.montant,
                  estRevenu: estRevenu,
                ),
                style: Styles.texteMontant.copyWith(color: couleurMontant),
              ),
              const Gap(4),
              Text(
                transaction.category,
                style: Styles.texteTitre.copyWith(
                  color: Styles.texteSecondaire(context),
                ),
              ),
              const Gap(20),
              const Divider(),
              _ligne(context, 'Type', transaction.type, couleurMontant),
              _ligne(context, 'Catégorie', transaction.category, couleurMontant),
              if (transaction.description.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: Styles.texteCorps.copyWith(
                          color: Styles.texteSecondaire(context),
                        ),
                      ),
                      const Gap(12),
                      Flexible(
                        child: Text(
                          transaction.description,
                          textAlign: TextAlign.end,
                          style: Styles.texteCorps,
                        ),
                      ),
                    ],
                  ),
                ),
              const Divider(),
              const Gap(12),
              if (!enEdition)
                Row(
                  children: [
                    Expanded(
                      child: Consumer<DatabaseProvider>(
                        builder: (context, database, child) =>
                            CustomTextButtonWidget(
                          couleurTexte: Styles.couleurDepense(context),
                          texte: "Supprimer",
                          action: () async {
                            await database.delteTransaction(
                              context,
                              id: transaction.id!,
                            );
                            if (context.mounted) Navigator.pop(context);
                          },
                          chargement: database.chargement,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Consumer<ModifierTransactionViewProvider>(
                        builder: (context, value, child) => FilledButton(
                          onPressed: () => value.afficherEdition(),
                          child: const Text("Modifier"),
                        ),
                      ),
                    ),
                  ],
                ),
              if (enEdition) ...[
                const Gap(8),
                ModifierTransaction(transaction: transaction),
              ],
              const Gap(16),
            ],
          ),
        ),
      ),
    );
  }
}
