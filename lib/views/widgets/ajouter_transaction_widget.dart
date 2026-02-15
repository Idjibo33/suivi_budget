import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Functions/creer_transaction.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_service_provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_dropdown_provider.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/document_utilisateur_service.dart';
import 'package:suivi_budget/Services/Firebase%20database/Firestore%20services/firestore_services.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/models/transaction.dart';
import 'package:suivi_budget/views/widgets/custom_filled_button_widget.dart';
import 'package:suivi_budget/views/widgets/custom_textfield_widget.dart';
import 'package:suivi_budget/views/widgets/depenses_categories_dropdown_widget.dart';
import 'package:suivi_budget/views/widgets/revenus_categories_dropdown_widget.dart';

class AjouterTransaction extends StatefulWidget {
  final TypeTransaction typeTransaction;
  const AjouterTransaction({super.key, required this.typeTransaction});

  @override
  State<AjouterTransaction> createState() => _AjouterTransactionState();
}

class _AjouterTransactionState extends State<AjouterTransaction> {
  // le controlleur du champ d'entrée du montant
  final TextEditingController montanttexte = TextEditingController();
  @override
  void dispose() {
    montanttexte.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String typeTransaction =
        widget.typeTransaction == TypeTransaction.revenus
        ? "Revenu"
        : "Depenses";
    // l'id de l'utilisateur actuel
    final String idUtilisateur = AuthServices().currentUser!.uid;

    // La valeur du dropdown des revenus
    final revenuCategorieDropdown =
        Provider.of<RevenusCategoriesDropdownProvider>(context, listen: false);

    return SafeArea(
      top: false,
      bottom: true,
      child: Padding(
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
                  Consumer<DocTransactionServiceProvider>(
                    builder: (context, value, child) =>
                        CustomFilledButtonWidget(
                          texte: "Enregistrer mon revenu",
                          action: () => creerTransaction(
                            context: context,
                            transaction: TransactionModel(
                              userId: idUtilisateur,
                              montant: int.parse(montanttexte.text),
                              category: revenuCategorieDropdown.categorie,
                              type: typeTransaction,
                              date: FieldValue.serverTimestamp(),
                            ),
                          ),
                          chargement: value.chargement,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
