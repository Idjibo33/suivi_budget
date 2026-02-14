import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:suivi_budget/Functions/ajouter%20_transaction.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';
import 'package:suivi_budget/views/widgets/depenses_categories_dropdown_widget.dart';
import 'package:suivi_budget/views/widgets/revenus_categories_dropdown_widget.dart';

class AjouterTransaction extends StatelessWidget {
  final TypeTransaction typeTransaction;
  const AjouterTransaction({super.key, required this.typeTransaction});

  @override
  Widget build(BuildContext context) {
    // le controlleur du champ d'entrée du montant
    TextEditingController montanttexte = TextEditingController();
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
                      typeTransaction == TypeTransaction.revenus
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
                    child: typeTransaction == TypeTransaction.revenus
                        ? RevenusCategoriesDropdownWidget()
                        : DepensesCategoriesDropdownWidget(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => ajouterTransaction(
                      context: context,
                      transaction: TransactionModel(
                        userId: AuthServices().currentUser!.uid,
                        montant: int.parse(montanttexte.text),
                        category: "Salaire",
                        type: "Revenu",
                        date: FieldValue.serverTimestamp(),
                      ),
                    ),
                    child: const Text("Enregistrer la transaction"),
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
