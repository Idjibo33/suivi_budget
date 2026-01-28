import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/revenus_categories_dropdown_provider.dart';
import 'package:suivi_budget/constants.dart';

class RevenusCategoriesDropdownWidget extends StatelessWidget {
  const RevenusCategoriesDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RevenusCategoriesDropdownProvider>(
      builder: (context, valueProvider, child) => DropdownButton(
        style: Styles.texteCorps.copyWith(color: Colors.black),
        icon: Transform.rotate(
          angle: -1.6,
          child: Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        underline: Container(),
        value: valueProvider.categorie,
        items: [
          const DropdownMenuItem(value: "salaire", child: Text("Salaire")),
          const DropdownMenuItem(value: "aide", child: Text("Aide")),
          const DropdownMenuItem(value: "freelance", child: Text("Freelance")),
          const DropdownMenuItem(
            value: "remboursement",
            child: Text("Remboursement"),
          ),
        ],
        onChanged: (value) {
          valueProvider.changerCategorie(value!);
        },
      ),
    );
  }
}
