import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/depenses_categories_dropdown_provider.dart';
import 'package:suivi_budget/constants.dart';

class DepensesCategoriesDropdownWidget extends StatelessWidget {
  const DepensesCategoriesDropdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> categories = ["Courses", "Loisirs", "Transport"];
    return Consumer<DepensesCategoriesDropdownProvider>(
      builder: (context, valueProvider, child) => DropdownButton(
        style: Styles.texteCorps.copyWith(color: Colors.black),
        icon: Icon(Icons.keyboard_arrow_down, size: 20),
        underline: Container(),
        value: valueProvider.categorie,
        items: categories.map((e) {
          return DropdownMenuItem(value: e, child: Text(e));
        }).toList(),
        onChanged: (value) {
          valueProvider.changerCategorie(value!);
        },
      ),
    );
  }
}
