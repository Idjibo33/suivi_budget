import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/providers.dart';

class FiltrageChoiceChipWidget extends StatelessWidget {
  const FiltrageChoiceChipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String filtre = context.watch<DatabaseProvider>().filtre;
    return Row(
      spacing: 12,
      children: [
        ChoiceChip(
          onSelected: (value) =>
              context.read<DatabaseProvider>().changerFiltre("toutes"),
          label: Text("Toutes"),
          selected: filtre == "toutes",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24),
          ),
        ),
        ChoiceChip(
          onSelected: (value) =>
              context.read<DatabaseProvider>().changerFiltre("revenus"),
          label: Text("Revenus"),
          selected: filtre == "revenus",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24),
          ),
        ),
        ChoiceChip(
          onSelected: (value) =>
              context.read<DatabaseProvider>().changerFiltre("depenses"),
          label: Text("Dépenses"),
          selected: filtre == "depenses",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24),
          ),
        ),
      ],
    );
  }
}
