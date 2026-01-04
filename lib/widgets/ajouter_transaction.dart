import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/database/transaction.dart';
import 'package:suivi_budget/providers.dart';

class AjouterTransaction extends StatefulWidget {
  final TypeTransaction typeTransaction;
  const AjouterTransaction({super.key, required this.typeTransaction});

  @override
  State<AjouterTransaction> createState() => _AjouterTransactionState();
}

class _AjouterTransactionState extends State<AjouterTransaction> {
  final now = DateTime.now().toString();
  TextEditingController montanttexte = TextEditingController();
  String revenuesCategorie = "salaire";
  String depensesCategorie = "courses";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
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
                Gap(12),
                Row(
                  children: [
                    Text("Montant", style: Styles.texteCorps),
                    Gap(4),
                    Text("(F cfa)", style: Styles.texteCorps),
                  ],
                ),
                Gap(8),
                TextField(
                  controller: montanttexte,
                  decoration: InputDecoration(
                    label: Text("ex : 10000", style: Styles.texteCorps),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                  ),
                  onChanged: (value) => montanttexte.text = value,
                ),
                Gap(12),
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
                        ? DropdownButton(
                            style: Styles.texteCorps.copyWith(
                              color: Colors.black,
                            ),
                            icon: Transform.rotate(
                              angle: -1.6,
                              child: Icon(Icons.arrow_back_ios_new, size: 20),
                            ),
                            underline: Container(),
                            value: revenuesCategorie,
                            items: [
                              DropdownMenuItem(
                                value: "salaire",
                                child: Text("Salaire"),
                              ),
                              DropdownMenuItem(
                                value: "aide",
                                child: Text("Aide"),
                              ),
                              DropdownMenuItem(
                                value: "freelance",
                                child: Text("Freelance"),
                              ),
                              DropdownMenuItem(
                                value: "remboursement",
                                child: Text("Remboursement"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                revenuesCategorie = value!;
                              });
                            },
                          )
                        : DropdownButton(
                            style: Styles.texteCorps.copyWith(
                              color: Colors.black,
                            ),
                            icon: Transform.rotate(
                              angle: -1.6,
                              child: Icon(Icons.arrow_back_ios_new, size: 20),
                            ),
                            underline: Container(),
                            value: depensesCategorie,
                            items: [
                              DropdownMenuItem(
                                value: "abonnement",
                                child: Text("Abonnement"),
                              ),
                              DropdownMenuItem(
                                value: "courses",
                                child: Text("Courses"),
                              ),
                              DropdownMenuItem(
                                value: "loisirs",
                                child: Text("Loisirs"),
                              ),
                              DropdownMenuItem(
                                value: "transport",
                                child: Text("Transport"),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                depensesCategorie = value!;
                              });
                            },
                          ),
                  ),
                ),

                Gap(24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      context.read<DatabaseProvider>().ajouterTransaction(
                        Transaction(
                          montant: int.parse(montanttexte.text),
                          category:
                              widget.typeTransaction == TypeTransaction.revenus
                              ? revenuesCategorie
                              : depensesCategorie,
                          type: widget.typeTransaction,
                          date: now,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Succès: Transaction enregistrée",
                            style: Styles.texteTitre.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          behavior: SnackBarBehavior.floating,
                          duration: Duration(seconds: 2),
                          backgroundColor:
                              widget.typeTransaction == TypeTransaction.revenus
                              ? Styles.couleurRevenu
                              : Styles.couleurDepense,
                        ),
                      );
                      Navigator.pop(context);
                    },
                    child: Text("Enregistrer la transaction"),
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
