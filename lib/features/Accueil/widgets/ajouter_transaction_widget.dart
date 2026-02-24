import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_dropdown_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_dropdown_provider.dart';
import 'package:suivi_budget/models/Notifications/snackbar_services.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/Services/transaction.dart';
import 'package:suivi_budget/Providers/database_provider.dart';
import 'package:suivi_budget/features/Accueil/widgets/custom_textfield_widget.dart';
import 'package:suivi_budget/features/Accueil/widgets/depenses_categories_dropdown_widget.dart';
import 'package:suivi_budget/features/Accueil/widgets/revenus_categories_dropdown_widget.dart';

class AjouterTransaction extends StatefulWidget {
  final TypeTransaction typeTransaction;
  const AjouterTransaction({super.key, required this.typeTransaction});

  @override
  State<AjouterTransaction> createState() => _AjouterTransactionState();
}

class _AjouterTransactionState extends State<AjouterTransaction> {
  // le controlleur du champ d'entrée du montant
  TextEditingController montanttexte = TextEditingController();
  @override
  void dispose() {
    montanttexte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String categorieRevenu = context
        .watch<RevenusCategoriesDropdownProvider>()
        .categorie;
    final String categorieDepense = context
        .watch<DepensesCategoriesDropdownProvider>()
        .categorie;
    // Lire l'heure actuelle
    final now = DateTime.now().toString();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.typeTransaction == TypeTransaction.revenus
                          ? "Nouveau revenu"
                          : "Nouvelle dépense",
                    ),
                    IconButton.filled(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: Colors.grey),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 4,
                  children: [
                    Text("Montant", style: Styles.texteCorps),
                    Text("(F cfa)", style: Styles.texteCorps),
                  ],
                ),
                CustomTextfieldWidget(
                  controlleurChamp: montanttexte,
                  label: "ex : 10000",
                  typeInput: TextInputType.numberWithOptions(),
                ),

                Text("Catégorie", style: Styles.texteCorps),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(16),
                  ),
                  color: Colors.grey[300],
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: widget.typeTransaction == TypeTransaction.revenus
                        ? RevenusCategoriesDropdownWidget()
                        : DepensesCategoriesDropdownWidget(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Consumer<DatabaseProvider>(
                    builder: (context, value, child) => FilledButton(
                      onPressed: () {
                        try {
                          value.ajouterTransaction(
                            Transaction(
                              montant: int.parse(montanttexte.text),
                              category:
                                  widget.typeTransaction ==
                                      TypeTransaction.revenus
                                  ? categorieRevenu
                                  : categorieDepense,
                              type: widget.typeTransaction,
                              date: now,
                            ),
                          );

                          if (context.mounted) {
                            SnackbarServices.successSnackbar(
                              context,
                              "Succès: Transaction enregistrée",
                            );
                            Navigator.pop(context);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            SnackbarServices.errorSnackbar(
                              context,
                              e.toString(),
                            );
                          }
                        }
                      },
                      child: const Text("Enregistrer la transaction"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
