import 'package:flutter/material.dart';
import 'package:suivi_budget/Core/constants.dart';

class CustomMontantTextfield extends StatelessWidget {
  final TextEditingController montantController;
  const CustomMontantTextfield({super.key, required this.montantController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: SizedBox(
        child: TextField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          controller: montantController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.money, size: 30),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 25),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            label: Text("Montant", style: texteCorps),
            hintText: "Ex: 10000",
            hintStyle: texteCorps,
          ),
        ),
      ),
    );
  }
}
