import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/Firestore%20services%20provider/doc_transaction_provider.dart';
import 'package:suivi_budget/constants.dart';
import 'package:suivi_budget/views/widgets/depenses_widgets.dart';
import 'package:suivi_budget/views/widgets/revenus_widgets.dart';

class SoldeWidget extends StatefulWidget {
  const SoldeWidget({super.key});

  @override
  State<SoldeWidget> createState() => _SoldeWidgetState();
}

class _SoldeWidgetState extends State<SoldeWidget> {
  // Les informations de l'utilisateur
  bool visible = false;
  void changervisiblite() async {
    setState(() {
      visible = !visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DocTransactionProvider>(
      builder: (context, transactions, child) => Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Stack(
                    children: [
                      Visibility(
                        visible: !visible,
                        child: Text("******", style: Styles.texteCorps),
                      ),
                      Visibility(
                        visible: visible,
                        child: Text(
                          "${transactions.soldeTotal().toString()} F CFA",
                          style: Styles.texteTitre,
                        ),
                      ),
                    ],
                  ),

                  Stack(
                    children: [
                      Visibility(
                        visible: !visible,
                        child: IconButton(
                          onPressed: () => changervisiblite(),
                          icon: const Icon(Icons.visibility),
                        ),
                      ),
                      Visibility(
                        visible: visible,
                        child: IconButton(
                          onPressed: () => changervisiblite(),
                          icon: const Icon(Icons.visibility_off),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RevenusWidgets(totalRevenus: transactions.totalRevenus()),
                  DepensesWidgets(totalDepenses: transactions.totalDepenses()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
