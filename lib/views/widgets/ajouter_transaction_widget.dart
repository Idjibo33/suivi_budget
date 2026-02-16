import 'package:flutter/material.dart';
import 'package:suivi_budget/Services/Firebase%20database/Authentification%20services/auth_services.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/Transactions/Depenses/ajouter_depense_view.dart';
import 'package:suivi_budget/views/Transactions/Revenus/ajouter_revenu_view.dart';

class AjouterTransaction extends StatefulWidget {
  const AjouterTransaction({super.key});

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
    /* //Le type de transaciton
    final String typeTransaction =
        widget.typeTransaction == TypeTransaction.revenus
        ? "Revenu"
        : "Depenses";*/
    // l'id de l'utilisateur actuel
    final String idUtilisateur = AuthServices().currentUser!.uid;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ajouter une transaction"),
          centerTitle: true,
          bottom: TabBar(
            unselectedLabelStyle: Styles.texteCorps,
            tabs: [
              Text("Revenu", style: Styles.texteTitre),
              Text("Dépense", style: Styles.texteTitre),
            ],
          ),
        ),
        body: TabBarView(
          children: [const AjouterRevenuView(), const AjouterDepenseView()],
        ),
      ),
    );
  }
}


/*SafeArea(
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
                          texte: "Enregistrer ma transaction",
                          action: () => creerTransaction(
                            context: context,
                            transaction: TransactionModel(
                              userId: idUtilisateur,
                              montant: int.parse(montanttexte.text),
                              category:
                                  widget.typeTransaction ==
                                      TypeTransaction.revenus
                                  ? revenusCategoriesDropdown.categorie
                                  : depensesCategoriesDropdown.categorie,
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
    );*/