import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/categorie.dart';
import 'package:suivi_budget/models/categories_par_defaut.dart';
import 'package:suivi_budget/models/etats/type_categorie.dart';
import 'package:suivi_budget/models/helpers/error_snackbar.dart';
import 'package:suivi_budget/models/helpers/icone_type_transaction.dart';
import 'package:suivi_budget/providers/database_provider.dart';

/// Gestion des catégories : création, renommage et archivage. Une catégorie
/// utilisée est archivée plutôt que supprimée ; « Autre » reste disponible et
/// ne peut pas être renommé, sa protection étant fondée sur son nom.
/// Le regroupement par famille alimente les graphiques.
class PanelCategories extends StatefulWidget {
  const PanelCategories({super.key});

  @override
  State<PanelCategories> createState() => _PanelCategoriesState();
}

class _PanelCategoriesState extends State<PanelCategories> {
  final TextEditingController _nom = TextEditingController();
  final TextEditingController _famille = TextEditingController();
  TypeCategorie _type = TypeCategorie.depense;

  @override
  void dispose() {
    _nom.dispose();
    _famille.dispose();
    super.dispose();
  }

  Future<void> ajouter() async {
    final String nom = _nom.text.trim();
    if (nom.isEmpty) {
      showErrorSnackbar(
        context,
        'Le nom de la catégorie ne peut pas être vide',
      );
      return;
    }
    final bool reussi = await context.read<DatabaseProvider>().ajouterCategorie(
      context,
      categorie: Categorie(
        nom: nom,
        type: _type.libelle,
        famille: _famille.text.trim().isEmpty ? 'Autre' : _famille.text.trim(),
        personnalisee: true,
      ),
    );
    if (reussi) {
      _nom.clear();
      _famille.clear();
    }
  }

  Future<void> renommer(Categorie categorie) async {
    final DatabaseProvider database = context.read<DatabaseProvider>();
    if (estIndispensable(categorie)) {
      showErrorSnackbar(
        context,
        'La catégorie « Autre » ne peut pas être renommée',
      );
      return;
    }
    final TextEditingController champ = TextEditingController(
      text: categorie.nom,
    );
    await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Renommer la catégorie'),
        content: TextField(controller: champ, autofocus: true),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () async {
              final String nouveau = champ.text.trim();
              if (nouveau.isEmpty) {
                showErrorSnackbar(
                  dialogContext,
                  'Le nom de la catégorie ne peut pas être vide',
                );
                return;
              }
              if (nouveau == categorie.nom) {
                if (dialogContext.mounted) Navigator.pop(dialogContext, false);
                return;
              }
              final bool reussi = await database.renommerCategorie(
                dialogContext,
                categorie: categorie,
                nouveauNom: nouveau,
              );
              if (reussi && dialogContext.mounted) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    champ.dispose();
  }

  Future<void> archiver(Categorie categorie) async {
    final DatabaseProvider database = context.read<DatabaseProvider>();
    final int usage = await database.nombreTransactionsCategorie(categorie);
    if (!mounted) {
      return;
    }
    await database.archiverCategorie(
      context,
      categorie: categorie,
      messageSucces: usage > 0
          ? 'Catégorie utilisée : elle a été archivée.'
          : 'Catégorie archivée',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, database, child) {
        final Map<String, List<Categorie>> parFamille =
            <String, List<Categorie>>{};
        for (final Categorie categorie in database.categories) {
          parFamille.putIfAbsent(categorie.famille, () => []).add(categorie);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Catégories', style: Styles.texteTitre),
            const Gap(4),
            Text(
              'Une catégorie de revenu ne peut pas servir de dépense.',
              style: Styles.texteCorps.copyWith(
                fontSize: 11,
                color: Styles.texteSecondaire(context),
              ),
            ),
            const Gap(12),
            for (final MapEntry<String, List<Categorie>> entree
                in parFamille.entries) ...[
              Text(
                entree.key.toUpperCase(),
                style: Styles.texteCorps.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: Styles.texteSecondaire(context),
                ),
              ),
              const Gap(4),
              for (final Categorie categorie in entree.value)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    iconeTypeTransaction(categorie.typeCategorie),
                    size: 16,
                  ),
                  title: Text(categorie.nom, style: Styles.texteCorps),
                  subtitle: Text(
                    categorie.personnalisee
                        ? 'Personnalisée'
                        : categorie.typeCategorie.libelle,
                    style: Styles.texteCorps.copyWith(fontSize: 10),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: estIndispensable(categorie)
                            ? 'Catégorie « Autre » : renommage impossible'
                            : 'Renommer',
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        onPressed: estIndispensable(categorie)
                            ? null
                            : () => renommer(categorie),
                      ),
                      IconButton(
                        tooltip: estIndispensable(categorie)
                            ? 'Catégorie « Autre » toujours disponible'
                            : 'Archiver',
                        icon: const Icon(Icons.archive_outlined, size: 18),
                        onPressed: estIndispensable(categorie)
                            ? null
                            : () => archiver(categorie),
                      ),
                    ],
                  ),
                ),
              const Gap(6),
            ],
            const Divider(),
            const Gap(6),
            TextField(
              controller: _nom,
              decoration: const InputDecoration(
                labelText: 'Nouvelle catégorie',
              ),
            ),
            const Gap(8),
            TextField(
              controller: _famille,
              decoration: const InputDecoration(
                labelText: 'Famille (graphiques)',
              ),
            ),
            const Gap(8),
            SegmentedButton<TypeCategorie>(
              segments: const [
                ButtonSegment(
                  value: TypeCategorie.depense,
                  label: Text('Dépense'),
                ),
                ButtonSegment(
                  value: TypeCategorie.revenu,
                  label: Text('Revenu'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (selection) =>
                  setState(() => _type = selection.first),
            ),
            const Gap(10),
            FilledButton.icon(
              onPressed: ajouter,
              icon: const Icon(Icons.add),
              label: const Text('Ajouter la catégorie'),
            ),
          ],
        );
      },
    );
  }
}
