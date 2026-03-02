import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suivi_budget/Providers/database_provider.dart';

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
              onSelected: (val) => value.changerFiltre(nouveauFiltre: 'toutes'),
              label: Text('Toutes'),
              selected: value.filtre == 'toutes',
            ),
            ChoiceChip(
              onSelected: (val) =>
                  value.changerFiltre(nouveauFiltre: 'revenus'),

              label: Text('Revenus'),
              selected: value.filtre == 'revenus',
            ),
            ChoiceChip(
              onSelected: (val) =>
                  value.changerFiltre(nouveauFiltre: 'depenses'),

              label: Text('Dépenses'),
              selected: value.filtre == 'depenses',
            ),
          ],
        );
      },
    );
  }
}
