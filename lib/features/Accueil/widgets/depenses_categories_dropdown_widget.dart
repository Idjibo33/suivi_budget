import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_dropdown_provider.dart';
import 'package:suivi_budget/constants.dart';

class DepensesCategoriesDropdownWidget extends StatelessWidget {
  const DepensesCategoriesDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DepensesCategoriesDropdownProvider>(
      builder: (context, valueProvider, child) => DropdownButton(
        style: Styles.texteCorps.copyWith(color: Colors.black),
        icon: Transform.rotate(
          angle: -1.6,
          child: Icon(Icons.arrow_back_ios_new, size: 20),
        ),
        underline: Container(),
        value: valueProvider.categorie,
        items: [
          const DropdownMenuItem(
            value: "abonnement",
            child: Text("Abonnement"),
          ),
          const DropdownMenuItem(value: "courses", child: Text("Courses")),
          const DropdownMenuItem(value: "loisirs", child: Text("Loisirs")),
          const DropdownMenuItem(value: "transport", child: Text("Transport")),
        ],
        onChanged: (value) {
          valueProvider.changerCategorie(value!);
        },
      ),
    );
  }
}
