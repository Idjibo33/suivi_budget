import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class CustomMontantTextfield extends StatelessWidget {
  final TextEditingController montantController;
  const CustomMontantTextfield({super.key, required this.montantController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SizedBox(
        width: double.infinity,
        child: TextField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          controller: montantController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.money),
            filled: true,
            fillColor: Styles.couleurbgSecondaire,
            contentPadding: EdgeInsets.symmetric(vertical: 25),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            label: Text("Montant", style: Styles.texteCorps),
            hintText: "Ex: 10000",
            hintStyle: Styles.texteCorps,
          ),
        ),
      ),
    );
  }
}
