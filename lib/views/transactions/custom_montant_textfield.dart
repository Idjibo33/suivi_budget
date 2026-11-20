import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class CustomMontantTextfield extends StatelessWidget {
  final TextEditingController montantController;
  const CustomMontantTextfield({super.key, required this.montantController});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      controller: montantController,
      style: Styles.texteMontantCompact,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.payments_outlined),
        labelText: "Montant",
        hintText: "Ex: 10000",
      ),
    );
  }
}
