/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FiltrageChoiceChipWidget extends StatelessWidget {
  const FiltrageChoiceChipWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, value, child) {
        return Row(
          spacing: 12,
          children: [
            ChoiceChip(
              onSelected: (value) =>
                  context.read<DatabaseProvider>().changerFiltre("toutes"),
              label: Text("Toutes ${value.transactions.length}"),
              selected: value.filtre == "toutes",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(24),
              ),
            ),
            ChoiceChip(
              onSelected: (value) =>
                  context.read<DatabaseProvider>().changerFiltre("revenus"),
              label: Text("Revenus ${value.transactionsRevenus.length}"),
              selected: value.filtre == "revenus",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(24),
              ),
            ),
            ChoiceChip(
              onSelected: (value) =>
                  context.read<DatabaseProvider>().changerFiltre("depenses"),
              label: Text("Dépenses ${value.transactionsDepenses.length}"),
              selected: value.filtre == "depenses",
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(24),
              ),
            ),
          ],
        );
      },
    );
  }
}*/
