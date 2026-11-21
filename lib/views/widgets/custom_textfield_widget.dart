import 'package:flutter/material.dart';

class CustomTextfieldWidget extends StatelessWidget {
  final IconData icone;
  final TextEditingController controlleurChamp;
  final String label;
  final TextInputType typeInput;
  const CustomTextfieldWidget({
    super.key,
    required this.label,
    required this.typeInput,
    required this.controlleurChamp,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: typeInput,
      controller: controlleurChamp,
      decoration: InputDecoration(
        prefixIcon: Icon(icone, size: 20),
        labelText: label,
      ),
    );
  }
}
