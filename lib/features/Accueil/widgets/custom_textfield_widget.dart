import 'package:flutter/material.dart';
import 'package:suivi_budget/constants.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final TextEditingController controlleurChamp;
  final String label;
  final TextInputType typeInput;
  const CustomTextfieldWidget({
    super.key,
    required this.label,
    required this.typeInput,
    required this.controlleurChamp,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: typeInput,
      controller: controlleurChamp,
      decoration: InputDecoration(
        label: Text(label, style: Styles.texteCorps),
        border: UnderlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.grey[300],
      ),
      onChanged: (value) => controlleurChamp.text = value,
    );
  }
}
